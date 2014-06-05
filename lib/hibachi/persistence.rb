require 'hibachi/node'

module Hibachi
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      # Write the given attrs to config and re-run Chef.
      def create from_attributes={}
        model = new from_attributes
        model.save
        model
      end
    end

    # Merge attrs and write to JSON.
    def save
      persist and chef
    end

    # Remove the given id from the JSON and re-run Chef.
    def destroy
      clear and chef
    end

    def persisted?
      @persisted
    end

    def new_record?
      (not persisted?)
    end

    private
    def persist
      @persisted ||= node.merge recipe => attributes
    end

    def clear
      node.delete id
    end

    def chef
      Hibachi.run_chef recipe, background: run_in_background?
    end

    def run_in_background?
      Hibachi.config.run_in_background
    end
  end
end
