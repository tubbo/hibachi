require 'spec_helper'

module Hibachi
  RSpec.describe Collection, type: :unit do
    subject { Collection.new Fake.model_name }

    it 'inits with model and param'
    it 'finds a model'
    it 'searches for models'
    it 'implements enumerable methods'
  end
end
