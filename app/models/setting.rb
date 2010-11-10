class Setting
  include MongoMapper::Document

  SCOPE_GLUE = '.'

  key :scope, String, :required => true
  key :name, String, :required => true
  key :value, String, :required => true

  def self.[](*scope)
    scope = scope.join SCOPE_GLUE
    @replies ||= {}
    @replies[scope] ||= Setting.first(:scope => scope).value rescue nil
  end
end
