require "simplecov"
SimpleCov.start do
  add_filter ".bundle"
end

$:.unshift File.expand_path("../..", __FILE__)

require "webmock/rspec"
require "json"
require "magnum/addons/hipchat"

WebMock.disable_net_connect!

def fixture_path(filename=nil)
  path = File.expand_path("../fixtures", __FILE__)
  filename.nil? ? path : File.join(path, filename)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def stub_api(token, room, body)
  stub_request(:post, "https://api.hipchat.com/v2/room/#{room}/notification").
    with(
      body: body,
      headers: {
        "Authorization" => "Bearer #{token}",
        "Content-Type"  => "application/json"
      }
    )
end