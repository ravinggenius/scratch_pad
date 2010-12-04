class AddonBase
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

  def self.enabled?
    enabled.include? self
  end

  def self.disabled?
    disabled.include? self
  end

  def self.enabled
    reply = Addon.all.map { |addon| self[addon.name] }
    reply.select! { |addon| addon.ancestors.include? self }
    reply
  end

  def self.disabled
    all - enabled
  end

  def self.enable
    Addon.first_or_create :name => self.name
  end

  def self.disable
    addon = Addon.first :name => self.name
    addon.delete
  end

  def self.initialize_settings
  end

  def self.register_setting(scope, name, default_value)
    setting = Setting.first_or_create :scope => scope
    setting.update_attributes :name => name, :value => default_value if setting.new?
  end

  def self.machine_name
    self.name.underscore
  end
end
