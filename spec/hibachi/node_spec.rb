require 'spec_helper'
require 'hibachi/node'

module Hibachi
  describe Node do
    subject do
      fixture_path = File.expand_path "../../fixtures", __FILE__
      Node.find "#{fixture_path}/chef.json"
    end

    it "finds the file at path" do
      expect(subject).to be_present
    end

    it "finds attributes in the file" do
      expect(subject.send(:parsed_json_attributes)).to be_present
      expect(subject.send(:parsed_json_attributes)).to_not be_empty
      expect(subject.send(:parsed_json_attributes).keys).to include(Hibachi.config.cookbook.to_s)
    end

    it "scopes attributes by cookbook" do
      expect(subject.attributes).to be_present
      expect(subject.attributes).to_not be_empty
    end

    it "enumerates over json attributes" do
      expect(subject).to respond_to :each
    end

    it "finds a given recipe's json" do
      expect(subject[:mock_settings]).to_not be_empty
    end

    it "exposes attributes as a hash" do
      expect(subject.attributes[:mock_settings]).to eq(subject[:mock_settings])
    end

    context "when writing to json" do
      before { subject[:from_node_spec] = { test: true } }

      it "sets recipe json" do
        expect(subject[:from_node_spec]).to_not be_nil
        expect(subject[:from_node_spec][:test]).to eq(true)
      end

      it "deletes recipe json" do
        expect(subject.delete(:from_node_spec)).to eq(true)
        expect(subject[:from_node_spec]).to be_nil
      end
    end
  end
end
