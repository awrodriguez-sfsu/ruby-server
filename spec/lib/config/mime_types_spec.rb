require 'rspec'

describe WebServer::Config::MimeTypes do

  context 'passed in file' do
    let(:options) {{file_name: 'spec/lib/config/test_files/mime.types.test'}}
    let(:mime_type_object) {WebServer::Config::MimeTypes.new(options)}

    describe '#mime_for_extension' do
      it 'should return mime for known extension (single entry)' do
        expect(mime_type_object.mime_for_extension('gif')).to eq 'image/gif'
      end

      it 'should return mime for known extension (multiple entries)' do
        expect(mime_type_object.mime_for_extension('jpeg')).to eq 'image/jpeg'
        expect(mime_type_object.mime_for_extension('jpg')).to eq 'image/jpeg'
        expect(mime_type_object.mime_for_extension('jpe')).to eq 'image/jpeg'
      end

      it 'should return default for unknown extension' do
        expect(mime_type_object/mime_for_extension('unknown')).to eq 'text/plain'
      end
    end

  end

  context 'default file location' do
    let(:mime_type_object) {WebServer::Config::MimeTypes.new}

    describe '#mime_for_extension' do
      it 'should return mime for known extension (single entry)' do
        expect(mime_type_object.mime_for_extension('css')).to eq 'text/css'
      end

      it 'should return mime for known extension (multiple entries)' do
        expect(mime_type_object.mime_for_extension('ics')).to eq 'text/calendar'
        expect(mime_type_object.mime_for_extension('ifb')).to eq 'text/calendar'
      end

      it 'should return default for unknown extension' do
        expect(mime_type_object/mime_for_extension('unknown')).to eq 'text/plain'
      end
    end
  end

end