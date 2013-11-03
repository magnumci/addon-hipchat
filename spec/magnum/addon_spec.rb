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
end