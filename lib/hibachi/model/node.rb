require 'hibachi/chef_server'

module Hibachi
  class Model
    module Node
      extend ActiveSupport::Concern

      module ClassMethods
        def node
          chef_server.current_node
        end

        def chef_server
          @chef_server ||= ChefServer.connect
        end
      end

      def node
        self.class.node
      end
    end
  end
end
