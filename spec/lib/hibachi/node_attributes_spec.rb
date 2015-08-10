require 'spec_helper'

module Hibachi
  RSpec.describe NodeAttributes, type: :unit do
    let :id do
      1
    end

    let :params do
      { test: false }
    end

    let :full_params do
      params.merge id: id
    end

    subject do
      NodeAttributes.new id, params, attributes
    end

    context 'with an array of hashes' do
      let :attributes do
        [full_params]
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

      context 'with a new id' do
        subject do
          NodeAttributes.new new_id, new_params, attributes
        end

        let :new_id do
          2
        end

        let :new_params do
          { foo: 'bar' }
        end

        it 'does not find an index' do
          expect(subject.index).to be_blank
        end

        it 'pushes onto the stack' do
          expect(subject.result).to eq(attributes.push(new_params))
        end
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
