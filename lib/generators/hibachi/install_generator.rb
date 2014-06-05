require 'rails/generators/base'

module Hibachi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installs Hibachi to this Rails app"
      source_root File.expand_path("../../templates", __FILE__)

      def copy_initializer
        template 'hibachi.rb', 'config/initializers/hibachi.rb'
      end
    end
  end
end
