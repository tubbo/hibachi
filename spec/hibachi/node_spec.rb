require 'spec_helper'
require 'hibachi/node'

module Hibachi
  describe Node do
    let :node do
      double 'Ridley::Node', :attributes => {
        :chef_environment => 'staging'
      }
    end

    let :collection do
      double 'Ridley::Collection'
    end

    let :client do
      double 'Ridley', :node => collection
    end

    before do
      allow(collection).to receive(:find).with('node.teve.inc').and_return node
      allow(Ridley).to recieve(:new).and_return client
    end

    subject { Node.new 'node.teve.inc' }

    it "initializes with a name" do
      expect(subject.name).to eq('node.teve.inc')
    end

    it "finds by name" do
      expect(Node.find('node.teve.inc')).to_not be_nil
    end

    it "tests whether a node exists" do
      expect(Node.exists?('node.teve.inc')).to eq(true)
      expect(Node.exists?('example.teve.inc')).to eq(false)
    end

    it "instantiates a new chef client" do
      expect(Node.chef).to be_a Ridley
    end

    it "sets node attributes" do
      expect(subject.set(attribute: 'value')).to eq(true)
      expect(subject).to respond_to(:[]=)
    end

    it "gets node attributes" do
      expect(subject.get(:chef_environment)).to eq('staging')
      expect(subject[:chef_environment]).to eq('staging')
    end

    context "when saving to the chef server" do
      before do
        allow(subject.send(:chef).to receive(:update).and_return true
      end

      it "updates attributes and saves" do
        expect(subject.update_attributes(attribute: 'value')).to eq(true)
      end

      it "saves current state of object to chef" do
        expect(subject.save).to eq(true)
      end
    end
  end
end
