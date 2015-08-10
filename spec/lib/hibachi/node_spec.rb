require 'spec_helper'

module Hibachi
  RSpec.describe Node, type: :unit do
    let :key do
      'test'
    end

    let :name do
      'hibachi'
    end

    let :attributes do
      {
        key => [
          { id: 1, test: false }
        ]
      }
    end

    let :nodes_collection do
      double 'Nodes'
    end

    let :node do
      double 'Ridley::NodeResource', attributes: attributes
    end

    let :client do
      double 'Ridley::Client', nodes: nodes_collection
    end

    subject do
      Node.new name: name, key: key
    end

    before do
      allow(nodes_collection).to receive(:find).with(name).and_return(node)
      allow(subject).to receive(:client).and_return(client)
    end

    it 'initializes with name and key' do
      expect(subject.name).to eq(name)
      expect(subject.key).to eq(key)
    end

    it 'scopes attributes by key' do
      expect(subject.attributes).to eq(attributes[key])
    end

    it 'updates attrs on the chef server' do
      allow(node).to \
        receive(:update)
        .with(attributes: [{ id: 1, test: true }])
        .and_return(true)
      expect(subject.update(id: 1, params: { test: true })).to eq(true)
    end

    it 'merges given attrs with current attrs' do
      expect(subject.send(:merge, 1, test: true)).to eq([
        { id: 1, test: true }
      ])
    end

    it 'finds node on the client' do
      expect(subject.send(:node)).to eq(node)
    end

    it 'uses ridley as an api client' do
      expect(subject.send(:client)).to eq(client)
    end

    it 'uses configuration from the main module' do
      expect(subject.send(:config)).to be_a(Hash)
    end
  end
end
