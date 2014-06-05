require 'hibachi'

class MockSetting < Hibachi::Model

  recipe :mock_settings

  attr_accessor :attributes, :name, :status, :is_active

  validates :name, :presence => true
  validates :status, :presence => true, :if => :active?

  def active?
    !!is_active
  end
end
