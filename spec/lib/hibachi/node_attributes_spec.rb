require 'spec_helper'

module Hibachi
  RSpec.describe NodeAttributes, type: :unit do
    let :id do
      1
    end

    let :params do
      { test: false }
    end

    subject do
      NodeAttributes.new id, params, attributes
    end

    context 'with an array of hashes' do
      let :attributes do
        [ params.merge(id: id) ]
      end

      let :index do
        subject.send :index
      end

      it 'finds index of item' do
        expect(index).to be_present
      end

      it 'merges params with attrs of positioned hash' do
        expect(subject.result).to eq([attributes[index].merge(params)])
      end
    end

    context 'with a hash' do
      let :id do
        nil
      end

      let :attributes do
        { test: true }
      end

      it 'merges params into attributes' do
        expect(subject.result).to eq(attributes.merge(params))
      end
    end
  end
end

