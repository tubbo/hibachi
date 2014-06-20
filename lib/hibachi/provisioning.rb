module Hibachi
  # Code for provisioning the box.
  module Provisioning
    extend ActiveSupport::Concern

    module ClassMethods
      # Accessor for the global Chef JSON.
      def node
        @node ||= Node.new(file_path: Hibachi.config.chef_json_path)
      end
    end

    # Accessor for the global Chef JSON in an instance.
    def node
      self.class.node
    end

    # Run chef for the given recipe.
    def chef
      Hibachi.run_chef recipe, background: run_in_background?
    end

    private
    def run_in_background?
      Hibachi.config.run_in_background
    end
  end
end
