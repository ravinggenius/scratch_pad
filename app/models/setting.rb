class Setting
  include MongoMapper::Document

  key :name, String, :required => true
  key :scope, String, :required => true

  belongs_to :option

  def self.[](code)
    @loaded ||= {}
    @loaded[code] ||= Setting.first('option.code' => code)
  end
end
