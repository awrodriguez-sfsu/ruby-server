require_relative 'config_reader'

module WebServer
  module Config
    class MimeTypes < ConfigReader

      def initialize(options = {})
        super(options[:file_name] || 'config/mime.types')

        load_config_file
      end

      def mime_for_extension(extension)
        @hashed_content[extension] || 'text/plain'
      end

      private
      def add(option)
        option[1..-1].each do |extension|
          @hashed_content[extension] = option[0]
        end
      end

    end

  end
end