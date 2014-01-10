require "magnum/addons/hipchat/version"
require "magnum/addons/hipchat/error"
require "magnum/addons/hipchat/message"

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
        message = Message.new(build)
        deliver(message.to_s)
      end

      private

      def connection
        @connection ||= Faraday.new("https://api.hipchat.com", {}) do |c|
          c.adapter(Faraday.default_adapter)
        end
      end

      def make_api_request(message)
        path    = "/v2/room/#{@room}/notification"
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
    end
  end
end
