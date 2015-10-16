module WebServer
  module Config
    class HttpdConfig

      RECOGNIZED_1_VALUE_OPTIONS = %w(ServerRoot DocumentRoot Listen AccessLog ErrorLog AccessFileName DirectoryIndex)
      RECOGNIZED_2_VALUE_OPTIONS = %w(Alias ScriptAlias)
      OPTION_DEFAULTS = {Listen: 80, AccessFileName: '.htaccess', DirectoryIndex: 'index.html', AccessLog: 'logs/access_log', ErrorLog: 'logs/error_log'}
      INTERPOLATED_OPTION_DEFAULTS = {AccessLog: 'ServerRoot', ErrorLog: 'ServerRoot'}

      attr_reader :file_name

      :content
      :hash

      def initialize(options = {})
        @file_name = options[:file_name] || 'config/httpd.conf'

        @hash = {}
        RECOGNIZED_2_VALUE_OPTIONS.each do |option_name|
          @hash[option_name] = {}
        end

        @content = File.read(@file_name)

        load_config_file
      end

      def server_root
        @hash['ServerRoot']
      end

      def document_root
        @hash['DocumentRoot']
      end

      def listen
        @hash['Listen']
      end

      def access_log
        @hash['AccessLog']
      end

      def error_log
        @hash['ErrorLog']
      end

      def access_file_name
        @hash['AccessFileName']
      end

      def directory_index
        @hash['DirectoryIndex']
      end

      def aliases
        @hash['Alias'].keys
      end

      def aliased_path(path)
        @hash['Alias'][path] || ''
      end

      def script_aliases
        @hash['ScriptAlias'].keys
      end

      def script_aliased_path(path)
        @hash['ScriptAlias'][path] || ''
      end

      private
      def load_config_file
        @content.each_line do |raw_line|
          clean_line = raw_line.strip.tr('"', '').gsub(/#.*/, '')

          array = clean_line.split(' ')

          unless array.length < 2
            if RECOGNIZED_1_VALUE_OPTIONS.include? array[0]
              if array[0] === 'Listen'
                add_single_value_option(array[0], array[1].to_i)
              else
                add_single_value_option(array[0], array[1])
              end
            elsif RECOGNIZED_2_VALUE_OPTIONS.include? array[0]
              add_double_value_option(array[0], array[1], array[2])
            end
          end
        end

        OPTION_DEFAULTS.each do |option_name, default_value|
          unless @hash.key? option_name.to_s
            if INTERPOLATED_OPTION_DEFAULTS.include? option_name
              @hash[option_name.to_s] = File.join(@hash[INTERPOLATED_OPTION_DEFAULTS[option_name]], default_value)
            else
              @hash[option_name.to_s] = default_value
            end
          end
        end
      end

      def add_single_value_option(option_name, value)
        @hash[option_name] = value
      end

      def add_double_value_option(option_name, value1, value2)
        @hash[option_name][value1] = value2
      end

    end

    class String
      def to_snake_case
        self.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
      end
    end

  end
end