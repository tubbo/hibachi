require 'spec_helper'

describe Hibachi do
  it 'has a version number' do
    expect(Hibachi::VERSION).not_to be nil
  end

  it 'autoloads objects' do
    %w(Engine Model Collection Node).each do |class_name|
      expect("Hibachi::#{class_name}".constantize).to be_defined
    end
  end

  it 'sets default configuration' do
    expect(Hibachi.config.org_name).to eq('waxpoetic')
    expect(Hibachi.config.node_name).to eq('hibachi')
  end
end
