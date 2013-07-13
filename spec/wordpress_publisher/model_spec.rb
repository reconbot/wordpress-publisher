require 'spec_helper'
require '../publishable_model'
describe WordpressPublisher::Model do

  context "::publish" do

    before do
      @article_data = {
        id: 1,
        title: "Howdy"
      }
    end

    it "creates new article when the article does not yet exist" do
      article = Article.publish(@article_data)
      article.should be_valid
      article.should be_persisted
      Article.first.should eq(article)
    end

    it "updates article when the article does exist" do
      article = create(:article, wp_id: @article_data[:id])
      updated = Article.publish(@article_data)
      updated.slug.should eq(@article_data[:slug])
      updated.slug.should_not eq(article.slug)
      article.should eq(updated)
    end

    it "raises an error when trying to publish bad data" do
      expect {
        Article.publish(nil)
      }.to raise_exception

      expect {
        Article.publish({})
      }.to raise_exception

    end

  end

end
