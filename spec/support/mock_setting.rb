require 'hibachi'

class MockSetting < Hibachi::Model
  recipe :mock_settings

  attr_accessor :name, :is_active

  validates :name, :presence => true

  def active?
    !!is_active
  end

  def id
    name
  end
end
