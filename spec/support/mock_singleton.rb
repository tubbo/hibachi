class MockSingleton < Hibachi::Model
  recipe :site_settings, :type => :singleton

  attr_accessor :title
end
