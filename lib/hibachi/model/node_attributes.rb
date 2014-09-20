require 'hibachi/chef_server'
require 'hibachi/converger'

module Hibachi
  class Model
    module NodeAttributes
      extend ActiveSupport::Concern

      module ClassMethods
        # A Ridley object to the current node.
        def node
          chef_server.current_node
        end

        private
        def chef_server
          @chef_server = ChefServer.connect
        end
      end

      # Accessor for the current node on the instance.
      def node
        self.class.node
      end

      protected
      def upload!
        node.update_attributes namespace => node_attributes
      end

      def converge!
        Converger.run recipe, in_background_if_configured
      end

      # Attributes loaded directly from the Chef server for this model.
      def attributes_from_chef_server
        case true
        when namespace.present? && collection?
          node.attributes[cookbook][namespace][id]
        when namespace.present?
          node.attributes[cookbook][namespace]
        else
          node.attributes[cookbook]
        end
      end
    end
  end
end
