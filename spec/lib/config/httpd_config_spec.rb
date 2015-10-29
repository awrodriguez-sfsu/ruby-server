require 'rspec'

describe WebServer::Config::HttpdConfig do

  context 'all options present in given httpd.conf' do
    let(:options) {{file_name: 'spec/lib/config/test_files/httpd.conf.test1'}}
    let(:httpd_config_object) {WebServer::Config::HttpdConfig.new(options)}

    describe '#server_root' do
      it 'should return ServerRoot' do
        expect(httpd_config_object.server_root).to eq '/absolute/path/to/server/root'
      end
    end

    describe '#document_root' do
      it 'should return DocumentRoot' do
        expect(httpd_config_object.document_root).to eq '/absolute/path/to/document/root'
      end
    end

    describe '#listen' do
      it 'should return Listen; as int' do
        expect(httpd_config_object.listen).to eq 9999
      end
    end

    describe '#access_log' do
      it 'should return AccessLog' do
        expect(httpd_config_object.access_log).to eq '/absolute/path/to/logs/access_log'
      end
    end

    describe '#error_log' do
      it 'should return ErrorLog' do
        expect(httpd_config_object.error_log).to eq '/absolute/path/to/logs/error_log'
      end
    end

    describe '#access_file_name' do
      it 'should return AccessFileName' do
        expect(httpd_config_object.access_file_name).to eq 'dothtaccess'
      end
    end

    describe '#directory_index' do
      it 'should return DirectoryIndex' do
        expect(httpd_config_object.directory_index).to eq 'directory_index.html'
      end
    end

    describe '#alias' do
      it 'should return hash of Alias' do
        expect(httpd_config_object.alias).to match({'/aa/' => '/absolute/alias/to/aa', '/bb/' => '/absolute/alias/to/bb'})
      end
    end

    describe '#alias_keys' do
      it 'should return array of aliased paths' do
        expect(httpd_config_object.alias_keys).to match(['/aa/', '/bb/'])
      end
    end

    describe '#alias_for' do
      it 'should return aliased path that exists' do
        expect(httpd_config_object.alias_for('/aa/')).to eq '/absolute/alias/to/aa'
      end

      it 'should return empty string if no aliased path found' do
        expect(httpd_config_object.alias_for('/does/not/exists')).to eq ''
      end
    end

    describe '#script_alias' do
      it 'should return hash of ScriptAlias' do
        expect(httpd_config_object.script_alias).to match({'/script_aa/' => '/absolute/script/alias/to/aa', '/script_bb/' => '/absolute/script/alias/to/bb'})
      end
    end

    describe '#script_alias_keys' do
      it 'should return array of script aliased paths' do
        expect(httpd_config_object.script_alias_keys).to match(['/script_aa/', '/script_bb/'])
      end
    end

    describe '#script_alias_for' do
      it 'should return script_aliased path that exists' do
        expect(httpd_config_object.script_alias_for('/script_aa/')).to eq '/absolute/script/alias/to/aa'
      end

      it 'should return empty string if no aliased path found' do
        expect(httpd_config_object.script_alias_for('/does/not/exists')).to eq ''
      end
    end

  end

  context 'some options missing in given httpd.conf' do
    let(:options) {{file_name: 'spec/lib/config/test_files/httpd.conf.test2'}}
    let(:httpd_config_object) {WebServer::Config::HttpdConfig.new(options)}

    describe '#listen' do
      it 'should return Listen; as int' do
        expect(httpd_config_object.listen).to eq 80
      end
    end

    describe '#access_file_name' do
      it 'should return AccessFileName' do
        expect(httpd_config_object.access_file_name).to eq '.htaccess'
      end
    end

    describe '#directory_index' do
      it 'should return DirectoryIndex' do
        expect(httpd_config_object.directory_index).to eq 'index.html'
      end
    end

  end

  context 'default httpd.conf file location' do
    let(:httpd_config_object) {WebServer::Config::HttpdConfig.new}

    describe '#file_name' do
      it 'should return file_name' do
        expect(httpd_config_object.file_name).to eq 'config/httpd.conf'
      end
    end

  end
end