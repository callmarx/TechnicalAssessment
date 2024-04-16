require 'rails_helper'
RSpec.describe LogProcessJob do
  let(:file_url) { "http://example.com/sample_log_file.log" }

  describe "#perform" do
    context "when the file_url returns HTTP Error" do
      before do
        stub_request(:get, file_url).to_return(status: 400)
        allow(Rails.logger).to receive(:error)
      end
      it "raise a OpenURI::HTTPError" do
        described_class.new.perform(file_url)

        expect(Rails.logger).to have_received(:error).with("HTTPError: 400 ")
      end
    end

    context "when the file_url returns 200" do
      let(:parser) { double("parser").as_null_object }
      let(:file) { double("file").as_null_object }
      before do
        allow(URI).to receive(:open).with(file_url).and_return(file) 
        allow(QuakeLog::Parser).to receive(:new).with(file).and_return(parser)
      end
      
      it "expect to call QuakeLog::Parser.new(file).perform" do
        described_class.new.perform(file_url)

        expect(parser).to have_received(:perform)
      end
    end
  end
end
