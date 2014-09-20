require 'rails/generators/named_base'

module Hibachi
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      desc "Generates a model for interacting with the Chef config"
      source_root File.expand_path("../../templates", __FILE__)

      argument :model_attributes, :type => :array

      class_option :recipe, \
        :type => :string,
        :description => "Specify recipe"

      class_option :collection, \
        :type => :boolean,
        :description => "Whether this model is a collection",
        :default => false

      def copy_model_definition
        template 'model.rb.erb', "app/models/#{file_path}.rb"
      end

      protected
      def model_class
        file_path.classify
      end

      def symbolized_model_attributes
        model_attributes.reject { |arg|
          arg =~ /\A--/
        }.map { |arg|
          ":#{arg}"
        }.join ', '
      end

      def recipe_config
        recipe_name + recipe_params
      end

      def recipe_params
        ", :collection => true" if collection?
      end

      def recipe_name
        return derived_recipe_name if derived_recipe_name =~ /\A\:/
        ":#{derived_recipe_name}" # prefer symbols
      end

      def derived_recipe_name
        return recipe_or_file_path.tableize if collection?
        recipe_or_file_path
      end

      def recipe_or_file_path
        return file_path if given_recipe.blank?
        given_recipe
      end

      private
      def collection?
        options[:collection]
      end

      def given_recipe
        options[:recipe]
      end
    end
  end
end
