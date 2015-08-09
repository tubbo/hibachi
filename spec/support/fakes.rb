module Hibachi
  class Fake < Model
    attribute :name
  end

  class Fakes < Model
    pluralized!

    attribute :name
  end
end
