module Magnum
  module Addons
    class Hipchat
      class Message
        COLORS = {
          "pass"  => "green",
          "fail"  => "red",
          "error" => "gray"
        }

        attr_reader :build

        def initialize(build)
          unless build.kind_of?(Hash)
            raise ArgumentError, "Hash required"
          end

          @build = Hashr.new(build)
        end

        def color
          COLORS[@build.status] || "yellow"
        end

        def to_s
          lines = [
            "<strong>#{ build.title }</strong>",
            "Commit: <a href='#{ build.commit_url }'>#{ commit_message }</a>",
            "Branch: #{ build.branch }",
            "Author: #{ build.author }",
            "Duration: #{ build.duration_string }",
            build_links
          ]

          lines.join("<br/>\n")
        end

        private

        def commit_message
          build.message.strip.split("\n").first
        end

        def build_links
          line = "<a href='#{ build.build_url }'>View Build</a>"

          if build.compare_url
            line << " - <a href='#{ build.compare_url }'>Commit Diff</a>"
          end

          line
        end
      end
    end
  end
end