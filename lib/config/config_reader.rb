module WebServer
  module Config
    class ConfigReader

      attr_reader :file_name, :content, :hashed_content

      def initialize(file_name)
        @file_name  = file_name
        @content    = File.read(file_name)

        @hashed_content = {}
      end

      private
      def load_config_file
        @content.each_line do |raw_line|
          option = clean_string(raw_line).split

          if valid_config_option?(option)
            add(option)
          end

        end
      end

      def add(option)

      end

      def clean_string(raw_line)
        raw_line.tr('"', '').gsub(/#.*/, '').strip
      end

      def valid_config_option?(option)
        false
      end

    end

  end
end