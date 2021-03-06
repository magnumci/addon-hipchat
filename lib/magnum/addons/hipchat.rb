require "magnum/addons/hipchat/version"
require "magnum/addons/hipchat/error"
require "magnum/addons/hipchat/message"

require "faraday"
require "hashr"
require "json"

module Magnum
  module Addons
    class Hipchat
      def initialize(options = {})
        @api_token = options[:api_token]
        @room      = options[:room]
        @from      = options[:from] || "Magnum"

        raise Error, "API token required" if @api_token.nil?
        raise Error, "Room ID required"   if @room.nil?
      end

      def run(build)
        deliver(Message.new(build))
      end

      private

      def connection
        @connection ||= Faraday.new("https://api.hipchat.com", {}) do |c|
          c.adapter(Faraday.default_adapter)
        end
      end

      def make_api_request(message)
        connection.send(:post, "/v2/room/#{@room}/notification") do |request|
          request.headers = headers
          request.body    = payload(message)
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

      def payload(message)
        hash = {
          message: message.to_s,
          message_format: "html",
          notify: true,
          color: message.color,
          from: @from
        }

        JSON.dump(hash)
      end

      def headers
        {
          "Authorization" => "Bearer #{@api_token}",
          "Content-Type"  => "application/json"
        }
      end
    end
  end
end
