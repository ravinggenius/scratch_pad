class Setting
  include MongoMapper::Document

  key :scope, String, :required => true
  key :name, String, :required => true

  many :options
  many :values

  def value_for(user)
    begin
      values.first :creator_id => user.id
    rescue
      values.first :creator_id => User.anonymous.id
    end
  end

  def self.[](code)
    Setting.first :scope => code
  end
end
