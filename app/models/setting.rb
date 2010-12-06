class Setting
  include MongoMapper::Document

  SCOPE_GLUE = '.'

  key :scope, String, :required => true
  key :name, String, :required => true
  key :value, String, :required => true

  def self.[](*scope)
    load_scope(scope).try :value
  end

  def self.first_in_scope(*scope)
    load_scope scope
  end

  private

  def self.load_scope(*scope)
    Setting.first(:scope => scope.join(SCOPE_GLUE))
  end
end
