require "magnum/addons/hipchat/version"
require "magnum/addons/hipchat/error"

require "faraday"
require "hashr"
require "json"

module Magnum
  module Addons
    class Hipchat
      def initialize(options={})
        @api_token = options[:api_token]
        @room      = options[:room]

        raise Error, "API token required" if @api_token.nil?
        raise Error, "Room ID required" if @room.nil?
      end

      def run(build)
        unless build.kind_of?(Hash)
          raise Error, "Hash required"
        end

        deliver(format_message(Hashr.new(build)))
      end

      private

      def connection
        @connection ||= Faraday.new("https://api.hipchat.com", {}) do |c|
          # c.use(Faraday::Response::Logger)
          c.adapter(Faraday.default_adapter)
        end
      end

      def make_api_request(message)
        path    = "/v2/room/#{@room}/message"
        payload = { message: message, message_format: "html" }
        headers = {
          "Authorization" => "Bearer #{@api_token}",
          "Content-Type"  => "application/json"
        }
 
        connection.send(:post, path) do |request|
          request.headers = headers
          request.body    = JSON.dump(payload)
        end
      end

      def deliver(message)
        response = make_api_request(message)
        json = JSON.load(response.body)

        unless response.success?
          raise Error, json["error"]["message"]
        end

        true
      end

      def format_message(build)
        lines = [
          "<strong>#{ build.title }</strong>",
          "Commit: <a href='#{ build.commit_url }'>#{ build.message }</a>",
          "Branch: #{ build.branch }",
          "Author: #{ build.author }",
          "Duration: #{ build.duration_string }",
          "<a href='#{ build.build_url }>View Build</a>"
        ]

        if build.compare_url
          lines << "<a href='#{ build.compare_url }'>View Diff</a>"
        end

        lines.join("<br/>")
      end
    end
  end
end
