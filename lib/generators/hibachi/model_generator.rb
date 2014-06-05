require 'rails/generators/named_base'

module Hibachi
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      desc "Generates a model for interacting with the Chef config"
      source_root File.expand_path("../../templates", __FILE__)

      def copy_model_definition
        template 'model.rb.erb', "app/models/#{file_path}.rb"
      end

      protected
      def model_class
        file_path.classify
      end

      def model_attributes
        ARGV[3..-1].map { |arg| ":#{arg}" }.join(', ')
      end
    end
  end
end
