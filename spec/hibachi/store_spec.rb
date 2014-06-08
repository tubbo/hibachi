require 'spec_helper'
require 'hibachi/store'

module Hibachi
  describe Store do
    it "creates a new model from scratch" do
      setting = MockSetting.create(name: 'from-scratch')
      expect(setting).to be_persisted
      expect(setting.destroy).to eq(true)
    end

    it "finds all of this type in the json" do
      setting = MockSetting.find 'test'
      expect(setting).to be_present
    end

    it "searches for a given model in the json" do
      settings = MockSetting.where(name: 'test')
      expect(settings).to_not be_empty
      expect(settings.first.name).to eq('test')
    end

    context "with an instance" do
      subject { MockSetting.new name: 'store' }

      it "validates given attributes" do
        expect(subject).to be_valid, subject.errors.full_messages.join(', ')
      end

      it "creates a new setting in the database" do
        expect(subject.save).to eq(true)
      end

      after { subject.destroy }
    end
  end
end
