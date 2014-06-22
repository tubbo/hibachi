class SingletonSetting < Hibachi::Model
  recipe :singleton_settings, :type => :singleton

  attr_accessor :name
end
