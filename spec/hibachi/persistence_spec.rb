require 'spec_helper'
require 'hibachi/persistence'

module Hibachi
  describe Persistence do
    subject do
      MockSetting.new name: 'persist', is_active: false
    end

    it "creates a new setting" do
      setting = MockSetting.create name: 'created', is_active: false
      expect(setting).to be_persisted
    end
  end
end
