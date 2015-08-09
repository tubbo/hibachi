require 'spec_helper'

module Hibachi
  RSpec.describe Model, type: :unit do
    subject { Fake.new name: 'test' }

    it 'merges id with params' do
      expect(subject.id).to eq(1)
    end

    it 'can be pluralized' do
      expect(Fakes).to be_pluralized
    end

    it 'is not pluralized by default' do
      expect(Fake).not_to be_pluralized
    end

    it 'defines fields as attributes' do
      expect(subject.name).to eq('test')
    end

    it 'creates new records' do
      fake = Fake.create name: 'test'
      expect(fake).to be_a(Fake)
      expect(fake).to be_valid
      expect(fake).to be_persisted
    end

    it 'returns the collection' do
      expect(Fake.all).to be_a(Collection)
    end

    it 'delegates methods to the collection' do
      expect(Fake).to respond_to(:each)
    end

    it 'reads and writes attributes' do
      expect(subject[:name]).to eq('test')
      subject[:name] = 'testing'
      expect(subject.name).to eq('testing')
    end

    it 'always has an id attribute' do
      expect(subject.id).to be_present
    end

    it 'saves to the chef node' do
      expect(subject.save).to be_true
      expect(subject).to be_persisted
    end

    it 'uses the param_key as its param when no id is present' do
      expect(subject.to_param).to eq(subject.param_name)
    end

    it 'is a new record when no id is present' do
      subject.id = nil
      expect(subject).to be_new_record
      expect(subject).not_to be_persisted
    end

    it 'is persisted when an id is present' do
      subject.id = 1
      expect(subject).to be_persisted
      expect(subject).not_to be_new_record
    end

    it 'updates attributes' do
      expect(subject.update_attributes(name: 'testing')).to eq(true)
      expect(subject.name).to eq('testing')
    end
  end
end
