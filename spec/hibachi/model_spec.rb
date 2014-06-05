require 'spec_helper'
require 'hibachi/model'

module Hibachi
  describe Model do
    subject do
      MockSetting.new name: 'example', is_active: false
    end

    it "sets attributes" do
      expect(subject.attributes).to_not be_empty
      expect(subject.attributes[:name]).to eq(subject.name)
    end

    it "finds full node json" do
      expect(MockSetting.node).to be_a Node
    end

    it "converts to json" do
      expect(subject.to_json).to_not be_empty
      expect(subject.to_json).to eq(subject.attributes.to_json)
    end
  end
end
