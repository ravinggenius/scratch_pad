class Setting
  include MongoMapper::Document

  key :code, String, :required => true
  key :name, String, :required => true
  key :scope, String, :required => true

  def self.[](code)
    @loaded ||= {}
    @loaded[code] ||= Setting.first_or_new(:code => code)
  end
end
