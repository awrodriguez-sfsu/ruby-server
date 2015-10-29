module WebServer
  module Config
    module BasicHttpdDirectives

      SINGLE_VALUES = {
          'ServerRoot'     => :to_s,
          'DocumentRoot'   => :to_s,
          'Listen'         => :to_i,
          'AccessLog'      => :to_s,
          'ErrorLog'       => :to_s,
          'AccessFileName' => :to_s,
          'DirectoryIndex' => :to_s
      }

      DOUBLE_VALUES = %w(Alias ScriptAlias)

      DEFAULTS      = {
          'Listen'         => 8080,
          'AccessLog'      => 'logs/access_log',
          'ErrorLog'       => 'logs/error_log',
          'AccessFileName' => '.htaccess',
          'DirectoryIndex' => 'index.html',
      }

      def self.valid?(option)
        (option.length == 2 and single_value? option[0]) or (option.length == 3 and double_value? option[0])
      end

      def self.single_value?(option_name)
        SINGLE_VALUES.keys.include? option_name
      end

      def self.double_value?(option_name)
        DOUBLE_VALUES.include? option_name
      end

    end
  end
end
