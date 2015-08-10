require 'spec_helper'

describe Hibachi do
  it 'has a version number' do
    expect(Hibachi::VERSION).not_to be nil
  end

  it 'autoloads objects' do
    %w(Engine Model Collection Node).each do |class_name|
      expect(defined?("Hibachi::#{class_name}".constantize)).to be_present
    end
  end

  it 'sets default configuration' do
    expect(Hibachi.config).to be_a(ActiveSupport::Configurable::Configuration)
  end
end
