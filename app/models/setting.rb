class Setting
  include MongoMapper::Document

  key :scope, String, :required => true
  key :name, String, :required => true

  many :options
  many :values

  # TODO need to load default value before user-specific value
  def value_for(user)
    values.first :creator_id => user.id
  end

  # this loads all values associated with this setting
  def self.[](code)
    @loaded ||= {}
    @loaded[code] ||= Setting.first(:scope => code)
  end
end
