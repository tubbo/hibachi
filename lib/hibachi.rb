require 'hibachi/version'
require 'hibachi/model'
require 'hibachi/railtie'

# Hibachi is a framework for editing Chef configuration using Ruby on
# Rails.

module Hibachi
  # A real easy accessor to the Railtie configuration.
  def self.config
    Rails.application.config.hibachi
  end
end
