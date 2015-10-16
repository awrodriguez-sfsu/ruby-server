module WebServer
  module Config
    class MimeTypes

      attr_reader :file_name

      :content
      :hash

      def initialize(options = {})
        @file_name = options[:file_name] || 'config/mime.types'

        @hash = {}

        @content = File.read(@file_name)

        load_config_file
      end

      def mime_for_extension(extension)
        @hash[extension] || 'text/plain'
      end

      private
      def load_config_file
        @content.each_line do |raw_line|
          clean_line = raw_line.strip.tr('"', '').gsub(/#.*/, '')

          array = clean_line.split(' ')

          unless array.length < 2
            array[1..-1].each do |extension|
              @hash[extension] = array[0]
            end
          end
        end
      end

    end
  end
end