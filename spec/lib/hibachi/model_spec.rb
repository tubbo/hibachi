require 'spec_helper'

module Hibachi
  RSpec.describe Model, type: :unit do
    subject { Fake.new name: 'test' }

    let :node do
      double 'Node', update: true
    end

    before do
      allow(subject).to receive(:node).and_return(node)
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
      allow(Node).to receive(:new).and_return(node)
      allow(node).to receive(:attributes).and_return({})

      fake = Fake.create name: 'test'

      expect(fake).to be_a(Fake)
      expect(fake).to be_valid
      allow(node).to receive(:attributes).and_return(fake.attributes)
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
      expect(subject).to respond_to(:id)
    end

    it 'saves to the chef node' do
      allow(node).to receive(:attributes).and_return({})
      allow(node).to \
        receive(:update)
        .with(subject.attributes, id: nil)
        .and_return(true)
      expect(subject).to be_valid
      expect(subject.send :create).to eq(true)
      expect(subject.save).to eq(true)
      allow(node).to receive(:attributes).and_return(subject.attributes)
      expect(subject).to be_persisted
    end

    it 'uses the param_key as its param when no id is present' do
      expect(subject.to_param).to eq(subject.model_name.param_key)
    end

    context 'when plural' do
      before do
        allow(subject).to receive(:plural?).and_return(true)
      end

      it 'is a new record when no id is present' do
        subject.id = nil

        expect(subject).to be_new_record
        expect(subject).not_to be_persisted
      end

      it 'is persisted when an id is present' do
        allow(subject).to receive(:plural?).and_return(true)
        subject.id = 1
        expect(subject).to be_persisted
        expect(subject).not_to be_new_record
      end
    end

    context 'when not plural' do
      before do
        allow(subject).to receive(:plural?).and_return(false)
      end

      it 'is persisted when attributes are equal' do
        allow(node).to receive(:attributes).and_return(subject.attributes)

        expect(subject).not_to be_new_record
        expect(subject).to be_persisted
      end

      it 'is not persisted when attributes differ' do
        allow(node).to receive(:attributes).and_return({})

        expect(subject).to be_new_record
        expect(subject).not_to be_persisted
      end
    end

    it 'updates attributes' do
      allow(node).to receive(:attributes).and_return(name: 'hello')
      expect(subject.update_attributes(name: 'testing')).to eq(true)
      expect(subject.name).to eq('testing')
    end
  end
end
