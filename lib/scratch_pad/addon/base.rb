module ScratchPad::Addon
  class Base
    def self.[](name)
      name = name.to_s.camelize
      if addon_types.map(&:title).include? name
        "ScratchPad::Addon::#{name}"
      else
        "#{title.pluralize}::#{name}"
      end.constantize
    end

    def self.<=>(other)
      name <=> other.name
    end

    def self.static_asset_types
      %w[images]
    end

    def self.root(relative = false)
      reply = Pathname.new(self.superclass.title.pluralize.underscore) + self.title.underscore
      reply = Rails.root + 'vendor' + 'addons' + reply unless relative
      reply
    end

    def self.images_path(relative = false)
      root(relative) + 'images'
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

    def self.images
      Dir[root + 'images' + '*'].entries.map { |i| Pathname.new i }
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
      name.split('::').last
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
        reply[addon_type] = addon_type.title.pluralize.constantize.constants.map { |constant| addon_type[constant] }
      end
      reply
    end

    def self.enabled?
      configurator.first(:name => machine_name).present?
    end

    def self.disabled?
      configurator.first(:name => machine_name).blank?
    end

    def self.enabled
      all.select &:enabled?
    end

    def self.disabled
      all.select &:disabled?
    end

    def self.enable
      ms = message_scope
      configurator.first_or_create :name => machine_name
      @settings ||= {}
      (@settings[ms] || []).each do |setting|
        Setting.first_or_create setting.merge(:scope => [ms, setting[:scope]].join(Setting::SCOPE_GLUE))
      end
      Rails.logger.info "#{self} enabled"
      ms
    end

    def self.disable
      ms = message_scope
      @settings ||= {}
      (@settings[ms] || []).each do |setting|
        Setting.first(:scope => [ms, setting[:scope]].join(Setting::SCOPE_GLUE)).try :delete
      end
      configurator.first(:name => self.machine_name).try :delete
      Rails.logger.info "#{self} disabled"
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

    def self.addon_type
      ancestors = self.ancestors
      ancestors[0..(ancestors.find_index(Base) - 1)].last
    end

    def self.addon_types
      reply = [
        Filter,
        NodeExtension,
        Theme,
        Widget
      ]
      reply.include?(self) ? [self] : reply
    end

    def self.configurator
      "#{addon_type.title}Configuration".constantize
    end

    protected

    def self.deprecate!(old_method, new_method)
      ActiveSupport::Deprecation.warn "#{name}.#{old_method} has been depricated. Please use #{name}.#{new_method} instead.", caller
    end

    # ScratchPad::Addon::Theme => 'theme'
    # ScratchPad::Addon::Widget => 'widget'
    # Themes::Branding => 'themes.branding'
    # Widgets::GoogleAnalytics => 'widgets.google_analytics'
    def self.message_scope
      addon_types.include?(self) ? machine_name : [addon_type.machine_name.pluralize, machine_name].join(Setting::SCOPE_GLUE)
    end
  end
end
