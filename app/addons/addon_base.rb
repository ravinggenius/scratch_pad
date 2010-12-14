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

  def self.machine_name
    self.name.underscore
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
    ms = message_scope
    Addon.first_or_create :name => self.name
    @settings ||= {}
    (@settings[ms] || []).each do |setting|
      Setting.first_or_create setting.merge(:scope => [ms, setting[:scope]].join(Setting::SCOPE_GLUE))
    end
    ms
  end

  def self.disable
    ms = message_scope
    @settings ||= {}
    (@settings[ms] || []).each do |setting|
      Setting.first(:scope => [ms, setting[:scope]].join(Setting::SCOPE_GLUE)).try :delete
    end
    Addon.first(:name => self.name).try :delete
    ms
  end

  def self.describe(phrase)
    @descriptions ||= {}
    @descriptions[message_scope] = phrase
  end

  def self.description
    (@descriptions || {})[message_scope]
  end

  def self.register_setting(scope, name, default_value)
    ms = message_scope
    @settings ||= {}
    @settings[ms] ||= []
    @settings[ms] << { :scope => scope, :name => name, :value => default_value }
  end

  def self.setting(scope)
    Setting[message_scope, scope]
  end

  def self.settings
    Setting.all_in_scope message_scope
  end

  protected

  def self.message_scope
    ancestors = self.ancestors
    ancestors[0..(ancestors.find_index(AddonBase) - 1)].map { |ancestor| ancestor.name.underscore }.reverse.join Setting::SCOPE_GLUE
  end
end
