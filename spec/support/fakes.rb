module Hibachi
  class Fake < Model
    field :name
  end

  class Fakes < Model
    pluralized!
    field :name
  end
end
