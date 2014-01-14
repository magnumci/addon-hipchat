require "spec_helper"

describe Magnum::Addons::Hipchat::Message do
  let(:payload) { JSON.load(fixture("build.json")) }
  let(:message) { described_class.new(payload) }

  describe "#initialize" do
    it "requires hash" do
      expect { described_class.new(nil) }.
        to raise_error ArgumentError, "Hash required"
    end
  end

  describe "#color" do
    let(:result) { message.color }

    context "when build passed" do
      before { payload["status"] = "pass" }

      it "returns green" do
        expect(result).to eq "green"
      end
    end

    context "when build failed" do
      before { payload["status"] = "fail" }

      it "returns red" do
        expect(result).to eq "red"
      end
    end

    context "when build errored" do
      before { payload["status"] = "error" }

      it "returns gray" do
        expect(result).to eq "gray"
      end
    end

    context "on invalid build status" do
      before { payload["status"] = "foobar" }

      it "returns yellow" do
        expect(result).to eq "yellow"
      end
    end
  end

  describe "#to_s" do
    let(:result) { message.to_s }

    it "returns string" do
      expect(result).to be_a String
    end

    it "includes build title" do
      expect(result).to include '<strong>[PASS] slack-notify #3 (master - 6f102f22) by Dan Sosedoff</strong><br/>'
    end

    it "includes commit url" do
      expect(result).to include "https://github.com/sosedoff/slack-notify/commit/6f102f22caac46945e16ada4f50df29a70ab2799"
    end

    it "includes commit message" do
      expect(result).to include "Commit: <a href='https://github.com/sosedoff/slack-notify/commit/6f102f22caac46945e16ada4f50df29a70ab2799'>Version bump: 0.1.1</a>"
    end

    it "includes branch" do
      expect(result).to include "Branch: master"
    end

    it "includes author" do
      expect(result).to include "Author: Dan Sosedoff"
    end

    it "includes duration" do
      expect(result).to include "Duration: 11s"
    end

    it "includes view build url" do
      expect(result).to include "<a href='https://magnum-ci.com/projects/201/builds/8683'>View Build</a>"
    end

    it "includes diff view url" do
      expect(result).to include "<a href='https://github.com/sosedoff/slack-notify/compare/42f7b7cdfc4b...6f102f22caac'>Commit Diff</a>"
    end

    it "is html formatted" do
      expect(result).to eq fixture("message.html")
    end

    context "when message includes multiple lines" do
      let(:payload) { JSON.load(fixture("build_multiline_message.json")) }

      it "includes first line of commit message" do
        expect(result).to include "Commit: <a href='https://github.com/sosedoff/slack-notify/commit/6f102f22caac46945e16ada4f50df29a70ab2799'>Commit message title</a>"
      end
    end
  end
end