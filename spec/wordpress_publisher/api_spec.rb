require 'spec_helper'

describe WordpressAPI do

  describe "publish_authors" do

    it "should publish and return all Author objects" do
      url = WordpressAPI.build_url 'get_author_index'
      stub = stub_wordpress_response 200, url, 'all_authors'
      authors = WordpressAPI.publish_authors
      authors.length.should eq(62)
      Author.count.should eq(62)
    end

  end

  describe "publish_post" do

      it "should publish and return a single Article object" do
        slug = 'article-title'
        url = WordpressAPI.build_url('get_post', {slug: slug}, :slug)
        stub = stub_wordpress_response 200, url, 'post'

        post = WordpressAPI.publish_post(slug)
        Article.first.should eq(post)
        Article.count.should eq(1)
      end

  end

  describe "search" do

    before do
      @search = "levo"
      @url = WordpressAPI.build_url('get_search_results', {search: @search, page:1}, :search)
      @stub = stub_wordpress_response 200, @url, 'search_levo'

      json = File.read("#{Rails.root.to_s}/spec/fixtures/wordpress/search.json")
      parsed = JSON.parse(json)
      @search_data = HashWithIndifferentAccess.new(parsed)
    end

    it "Returns results" do
      @search_data[:posts].each do |post|
        Article.publish post
      end

      articles = WordpressAPI.search(@search)
      articles.count.should eq(10)
      articles.length.should eq(10)
    end

    it "supports pagination" do
      @search_data[:posts].each do |post|
        Article.publish post
      end

      search_results = WordpressAPI.search(@search)
      search_results.length.should eq(10)
      search_results.current_page.should eq(1)
      search_results.total_pages.should eq(30)
    end

  end

  describe "publish_all" do

    before do
      @url = WordpressAPI.build_url('get_recent_posts', {page:1}, :search)
      @stub = stub_wordpress_response 200, @url, 'all_articles_page_1'
    end

    it "publishes and returns Articles" do
      articles = WordpressAPI.publish_all
      Article.all.should include(articles.first)
      Article.count.should eq(10)
    end

    it "supports pagination" do
      articles = WordpressAPI.publish_all
      articles.length.should eq(10)
      articles.current_page.should eq(1)
      articles.total_pages.should eq(59)
    end

  end

end