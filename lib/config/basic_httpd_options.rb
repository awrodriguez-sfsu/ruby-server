module WebServer
  module Config
    class BasicHttpdOptions

      attr_reader :single_value, :double_value, :defaults, :option_methods

      def initialize
        @single_value = %w(ServerRoot DocumentRoot Listen AccessLog ErrorLog AccessFileName DirectoryIndex)
        @double_value = %w(Alias ScriptAlias)

        @option_methods = {
            'server_root'               => '[\'ServerRoot\']',
            'document_root'             => '[\'DocumentRoot\']',
            'listen'                    => '[\'Listen\'].to_i',
            'port'                      => '[\'Listen\'].to_i',
            'access_log'                => '[\'AccessLog\']',
            'error_log'                 => '[\'ErrorLog\']',
            'access_file_name'          => '[\'AccessFileName\'] or \'.htaccess\'',
            'directory_index'           => '[\'DirectoryIndex\'] or \'index.html\'',
            'aliases'                   => '[\'Alias\'].keys',
            'script_aliases'            => '[\'ScriptAlias\'].keys',
            'aliased_path(path)'        => '[\'Alias\'][path] or \'\'',
            'script_aliased_path(path)' => '[\'ScriptAlias\'][path] or \'\'',
        }

      end

      def valid?(option)
        (option.length == 2 and single_value? option[0]) or (option.length == 3 and double_value? option[0])
      end

      def single_value?(option_name)
        @single_value.include? option_name
      end

      def double_value?(option_name)
        @double_value.include? option_name
      end

      private
      def set_return_type(option_name)
        @single_value[option_name] || @double_value[option_name]
      end

    end

  end
end
