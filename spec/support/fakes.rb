module Hibachi
  # :nodoc:
  class Fake < Model
    attribute :name
  end

  # :nodoc:
  class Fakes < Model
    pluralized!

    attribute :name
  end
end
