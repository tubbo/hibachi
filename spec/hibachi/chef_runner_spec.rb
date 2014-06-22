require 'spec_helper'
require 'hibachi/chef_runner'

module Hibachi
  describe ChefRunner do
    subject do
      double 'Hibachi', \
        config: Hibachi.config,
        recipe_name: 'recipe[pro::default]'
    end
    before do
      subject.class_eval { include Hibachi::ChefRunner }
    end

    it "runs chef" do
      allow(subject).to receive(:run).and_return true
      expect(subject.run_chef(:pro)).to eq(true)
    end

    it "runs chef in the background" do
      allow(subject).to receive(:run_chef_in_bg).and_return true
      expect(subject.run_chef(:pro, background: true)).to eq(true)
    end
  end
end
