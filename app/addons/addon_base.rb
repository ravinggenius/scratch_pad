class AddonBase
  def self.[](name)
    name.to_s.camelize.constantize
  end

  def self.<=>(other)
    name <=> other.name
  end

  def self.root(relative = false)
    reply = Pathname.new(self.superclass.title.pluralize.underscore) + self.title.underscore
    reply = Rails.root + 'vendor' + 'addons' + reply unless relative
    reply
  end

  def self.scripts_path(relative = false)
    root(relative) + 'styles'
  end

  def self.styles_path(relative = false)
    root(relative) + 'styles'
  end

  def self.views_path(relative = false)
    root(relative) + 'views'
  end

  def self.views
    deprication_warning :views, :views_path
    views_path
  end

  def self.scripts
    Dir[root + 'scripts' + '*.js'].entries.map { |s| Pathname.new s }
  end

  def self.styles
    Dir[root + 'styles' + '*'].entries.map { |s| Pathname.new s }
  end

  def self.stylesheets
    styles.map { |style| style unless style.basename.to_s.split('.').first.starts_with?('_') }.compact
  end

  def self.title
    name
  end

  def self.machine_name
    title.underscore
  end

  def self.all
    all_by_type.values.flatten
  end

  def self.all_by_type
    reply = {}

    addon_types.each do |addon_type|
      reply[addon_type] = []

      (Rails.root + 'vendor' + 'addons' + addon_type.machine_name.pluralize).children.each do |child|
        name = child.basename.to_s
        next if name =~ /^\./
        reply[addon_type] << addon_type[name]
      end
    end

    reply
  end

  def self.enabled?
    enabled.include? self
  end

  def self.disabled?
    disabled.include? self
  end

  def self.enabled
    reply = Addon.all.map { |addon| AddonBase[addon.name] }
    reply.select! { |addon| addon.ancestors.include? self }
    reply
  end

  def self.disabled
    all - enabled
  end

  def self.enable
    ms = message_scope
    Addon.first_or_create :name => self.title
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
    Addon.first(:name => self.title).try :delete
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

  def self.addon_types
    reply = [
      Filter,
      NodeExtension,
      Theme,
      Widget
    ]
    reply = [self] if reply.include? self
    reply
  end

  protected

  def self.deprication_warning(old_method, new_method)
    Rails.logger.info "#{name}.#{old_method} has been depricated. Please use #{name}.#{new_method} instead."
  end

  def self.message_scope
    ancestors = self.ancestors
    ancestors[0..(ancestors.find_index(AddonBase) - 1)].map { |ancestor| ancestor.name.underscore }.reverse.join Setting::SCOPE_GLUE
  end
end
