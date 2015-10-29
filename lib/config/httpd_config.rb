require_relative 'config_reader'
require_relative 'basic_httpd_directives'

module WebServer
  module Config
    class HttpdConfig < ConfigReader

      attr_reader :httpd_options

      def initialize(options = {}, httpd_options = BasicHttpdDirectives)
        super(options[:file_name] || 'config/httpd.conf')
        @httpd_options = httpd_options

        @httpd_options::DOUBLE_VALUES.each do |inner_hash|
          @hashed_content[inner_hash] = {}
        end

        load_config_file
        load_defaults
        expose_options
      end

      private
      def load_defaults
        @httpd_options::DEFAULTS.each do |option_name, option_default|
          unless @hashed_content.key? option_name
            @hashed_content[option_name] = option_default
          end
        end
      end

      def expose_options
        expose_single_options
        expose_double_options
      end

      def expose_single_options
        @httpd_options::SINGLE_VALUES.each do |option_name, return_type|
          HttpdConfig::class_eval <<-EOS
            def #{to_snake_case(option_name)}
              @hashed_content['#{option_name}'].send(:#{return_type})
            end
          EOS
        end
      end

      def expose_double_options
        @httpd_options::DOUBLE_VALUES.each do |option_name|
          HttpdConfig::class_eval <<-EOS

            def #{to_snake_case(option_name)}
              @hashed_content['#{option_name}']
            end

            def #{to_snake_case(option_name)}_keys
              @hashed_content['#{option_name}'].keys
            end

            def #{to_snake_case(option_name)}_for(sub_option)
              @hashed_content['#{option_name}'][sub_option] or ''
            end
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

      private
      def to_snake_case(string)
        string.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
      end

    end
  end
end