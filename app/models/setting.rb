class Setting
  include MongoMapper::Document

  key :scope, String, :required => true
  key :name, String, :required => true

  many :options
  many :values

  def user_value
    v = values.first :creator_id => User.current.id
    v = values.first :creator_id => User.anonymous.id if v.nil?
    v.nil? ? nil : v.value
  end

  def self.[](code)
    Setting.first :scope => code
  end
end
