require_relative 'config_reader'

module WebServer
  module Config
    class HttpdConfig < ConfigReader

      attr_reader :httpd_options

      def initialize(options = {}, httpd_options = BasicHttpdOptions.new)
        super(options[:file_name] || 'config/httpd.conf')
        @httpd_options = httpd_options

        @httpd_options.double_value.each do |inner_hash|
          @hashed_content[inner_hash] = {}
        end

        load_config_file
        expose_options
      end

      private
      def expose_options
        @httpd_options.option_methods.each do |method_name, content_access|
          HttpdConfig::class_eval <<-EOS
            def #{method_name}                 # def aliases
              @hashed_content#{content_access} #   @hashed_content['Alias'].keys
            end                                # end
          EOS
        end
      end

      def valid_config_option?(option)
        @httpd_options.valid? option
      end

      def add(option)
        if @httpd_options.single_value? option[0]
          @hashed_content[option[0]] = option[1]
        else
          @hashed_content[option[0]][option[1]] = option[2]
        end
      end

    end
  end
end