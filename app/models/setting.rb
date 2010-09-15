class Setting
  include MongoMapper::Document

  key :scope, String, :required => true
  key :name, String, :required => true

  many :options
  many :values

  def user_value
    begin
      values.first :creator_id => User.current.id
    rescue
      values.first :creator_id => User.anonymous.id
    end.value
  end

  def self.[](code)
    Setting.first :scope => code
  end
end
