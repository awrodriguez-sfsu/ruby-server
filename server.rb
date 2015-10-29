require_relative 'lib/config/httpd_config'
require_relative 'lib/config/mime_types'
require_relative 'lib/worker'

require 'socket'

module WebServer
  class Server

    attr_reader :httpd_settings, :mime_settings, :logger

    def initialize
      @httpd_settings = Config::HttpdConfig.new
      @mime_settings  = Config::MimeTypes.new
      @logger         = Logger.new(@httpd_settings, {echo: true})
    end

    def start
      server = TCPServer.open('localhost', @httpd_settings.port)
      puts 'server running'

      loop do

        Thread.abort_on_exception = true
        Thread.start(server.accept) do |client_connection|
          Worker.new(client_connection, self).process_request
        end
      end
    end

  end
end

WebServer::Server.new.start