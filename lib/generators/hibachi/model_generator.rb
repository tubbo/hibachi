require 'rails/generators/named_base'

module Hibachi
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      desc "Generates a model for interacting with the Chef config"
      source_root File.expand_path("../../templates", __FILE__)

      argument :model_attributes, :type => :array
      class_option :recipe, :type => :string, :description => "Specify recipe"

      def copy_model_definition
        template 'model.rb.erb', "app/models/#{file_path}.rb"
      end

      protected
      def model_class
        file_path.classify
      end

      def symbolized_model_attributes
        ARGV[1..-1].reject { |arg|
          arg =~ /\A--/
        }.map { |arg|
          ":#{arg}"
        }.join ', '
      end

      def recipe_name
        return "'#{derived_recipe_name}'" if derived_recipe_name =~ /\:/
        ":#{derived_recipe_name}" # prefer symbols
      end

      def derived_recipe_name
        options[:recipe] || default_recipe_name
      end

      def default_recipe_name
        ":#{file_path.tableize}"
      end
    end
  end
end
