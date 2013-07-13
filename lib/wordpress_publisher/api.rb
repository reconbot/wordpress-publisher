module WordpressPublisher
  module Api
    class << self

      def publish_authors
        data = http_fetch build_url('get_author_index')
        authors = data[:authors].map { |author_data|
          Author.publish(author_data)
        }
        authors
      end

      def publish_post(slug)
        data = http_fetch build_url('get_post', {slug: slug}, :slug)
        Article.publish(data[:post])
      end

      def publish_all(page = 1)
        opt = {
          page: page
        }
        data = http_fetch build_url('get_recent_posts', opt)
        articles = data[:posts].map { |article_data|
          Article.publish(article_data)
        }
        SearchResults.new(articles, page, data[:pages])
      end

      def search(search, page = 1)
        opt = {
          search: search,
          page: page
        }
        data = http_fetch build_url('get_search_results', opt, :search)
        wp_ids = data[:posts].map { |article_data|
          article_data[:id]
        }
        results = Article.where(wp_id: wp_ids)
        SearchResults.new(results, page, data[:pages])
      end

      def url_root
        "#{AppConfig.content_url}/api"
      end

      def build_url(func, opt = {}, *required_fields)
        opts = []
        (required_fields + [:count, :page]).each { |field|
          if opt[field]
            val = CGI::escape(opt[field].to_s)
            opts.push "#{field.to_s}=#{val}"
          end
        }
        url = "#{url_root}/#{func.to_s}/"
        unless opts.empty?
          url = "#{url}?" + opts.join("&")
        end
        url
      end

      def http_fetch(url)
        response = HTTParty.get url, :follow_redirects => false
        if response.code != 200
          raise "http_error"
        end
        parsed = JSON.parse(response.body)
        data = HashWithIndifferentAccess.new parsed

        if data[:error] == "Not found."
          raise "not_found"
        end

        if data[:status] != "ok"
           raise "not_ok"
        end

        data
      end

    end

    class SearchResults < Array

      attr_reader :current_page, :total_pages

      def initialize(result, current_page, total_pages)
        super(result)
        @result = result
        @current_page = current_page
        @total_pages = total_pages
      end

      def method_missing(meth, *args)
        @result.send(meth, args)
      end

    end
  end
end
