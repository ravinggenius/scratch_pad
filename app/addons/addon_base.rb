class AddonBase
  def install
  end

  def self.[](name)
    name.to_s.camelize.constantize
  end

  def self.<=>(other)
    name <=> other.name
  end

  def self.root
    Rails.root + 'vendor' + 'addons' + self.superclass.name.pluralize.underscore + self.name.underscore
  end

  def self.scripts
    Dir[root + 'scripts' + '*.js'].entries.map { |s| Pathname.new s }
  end

  def self.styles
    Dir[root + 'styles' + '*'].entries.map { |s| Pathname.new s }
  end

  def self.views
    root + 'views'
  end

  def self.all
    path = Rails.root + 'vendor' + 'addons' + self.name.pluralize.underscore
    path.entries.reject { |entry| entry.to_s =~ /^\./ }.sort.map { |name| self[name] }
  end

  def self.enabled
    Addon.all.map { |addon| self[addon.name] }
  end

  def self.disabled
    all - enabled
  end

  def self.install
  end

  def self.register_setting(scope, name, default_value)
    setting = Setting.first_or_create :scope => scope
    setting.update_attributes :name => name, :value => default_value if setting.new?
  end

  def self.title
    self.name.titleize
  end

  def self.machine_name
    self.name.underscore
  end
end
