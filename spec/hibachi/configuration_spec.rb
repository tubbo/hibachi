require 'spec_helper'
require 'hibachi/configuration'

module Hibachi
  describe Configuration do
    subject { double 'Hibachi' }

    before do
      subject.class_eval { include Configuration }
    end

    it "sets configuration" do
      subject.configure { |c| c.run_in_background = true }
      expect(subject.config.run_in_background).to eq(true)
    end

    it "returns configuration" do
      expect(subject.config.chef_json_path).to match(/chef\.json\Z/)
      expect(subject.config.chef_dir).to_not be_nil
      expect(subject.config.log_path).to match(/hibachi\.log\Z/)
      expect(subject.config.run_in_background).to eq(false)
    end

    after do
      subject.configure { |c| c.run_in_background = false }
      expect(subject.config.run_in_background).to eq(false)
    end
  end
end
