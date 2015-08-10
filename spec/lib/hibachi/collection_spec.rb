require 'spec_helper'

module Hibachi
  RSpec.describe Collection, type: :unit do
    let :id do
      1
    end

    let :name do
      'test'
    end

    let :model do
      Fake.new id: id, name: name
    end

    let :node do
      double 'Node', attributes: [ model.attributes ]
    end

    subject { Collection.new model.model_name }

    before do
      allow(subject).to receive(:node).and_return(node)
    end

    it 'inits with model and param' do
      expect(subject.model).to eq(model.model_name.to_s.constantize)
      expect(subject.param).to eq(model.model_name.param_key)
    end

    it 'finds a model' do
      expect(subject.find(id)).to eq(model)
    end

    it 'searches for models' do
      expect(subject.where(name: name)).to include(model)
    end

    it 'implements enumerable methods' do
      expect(subject.map(&:name)).to include(name)
    end
  end
end
