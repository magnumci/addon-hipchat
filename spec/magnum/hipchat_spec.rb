require "spec_helper"

describe Magnum::Addons::Hipchat do
  describe "#initialize" do
    it "raises error if api token is nil" do
      expect { described_class.new }.
        to raise_error Magnum::Addons::Hipchat::Error, "API token required"
    end

    it "raises error if room is nil" do
      expect { described_class.new(api_token: "token") }.
        to raise_error Magnum::Addons::Hipchat::Error, "Room ID required"
    end
  end

  describe "#run" do
    let(:addon)   { described_class.new(api_token: "token", room: 12345) }
    let(:payload) { JSON.load(fixture("build.json")) }

    it "requires hash object" do
      expect { addon.run(nil) }.
        to raise_error ArgumentError, "Hash required"
    end

    it "sends notification" do
      stub_request(:post, "https://api.hipchat.com/v2/room/12345/notification").
         with(:body => fixture("payload.json"),
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
         to_return(:status => 204, :body => "", :headers => {})

      addon.run(payload)
    end

    context "when api token is invalid" do
      before do
        stub_request(:post, "https://api.hipchat.com/v2/room/12345/notification").
         with(:body => fixture("payload.json"),
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
         to_return(:status => 401, :body => fixture("unauthorized.json"), :headers => {})
      end

      it "raises error" do
        expect { addon.run(payload) }.
          to raise_error Magnum::Addons::Hipchat::Error, "Invalid OAuth session"
      end
    end

    context "when room id is invalid" do
      before do
        stub_request(:post, "https://api.hipchat.com/v2/room/12345/notification").
         with(:body => fixture("payload.json"), 
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
         to_return(:status => 404, :body => fixture("room_not_found.json"), :headers => {})
      end

      it "raises error" do
        expect { addon.run(payload) }.
          to raise_error Magnum::Addons::Hipchat::Error, "Room not found"
      end
    end
  end
end