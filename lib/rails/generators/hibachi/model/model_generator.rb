module Hibachi
  # Generate a new +Hibachi::Model+ representing anything you want.
  #
  # @example
  #   rails g hibachi:model NetworkInterface name is_auto:boolean --plural
  class ModelGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    class_option :plural, type: :boolean, default: false

    # Create the model file.
    #
    # @private
    def create_model_file
      template 'model.rb.tt', model_file_path
    end

    hook_for :test_framework

    private

    # @private
    def model_file_path
      File.join 'app', 'models', class_path, "#{file_name}.rb"
    end
  end
end
