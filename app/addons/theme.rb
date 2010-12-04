class Theme < AddonBase
  def self.admin?
    machine_name.end_with? '_admin'
  end

  def self.frontend
    enabled.reject { |theme| theme.admin? }
  end

  def self.backend
    enabled.select { |theme| theme.admin? }
  end

  def self.frontend?
    Theme.frontend.include? self
  end

  def self.backend?
    Theme.backend.include? self
  end

  def self.initialize_settings
    register_setting 'addon.theme.frontend',          'Frontend Theme',                     :default
    register_setting 'addon.theme.backend',           'Backend Theme',                      :default_admin
    register_setting 'addon.theme.support.khtml',     'Experimental Support For KHTML',     false
    register_setting 'addon.theme.support.microsoft', 'Experimental Support For Microsoft', false
    register_setting 'addon.theme.support.mozilla',   'Experimental Support For Mozilla',   false
    register_setting 'addon.theme.support.opera',     'Experimental Support For Opera',     false
    register_setting 'addon.theme.support.svg',       'Experimental Support For SVG',       true
    register_setting 'addon.theme.support.webkit',    'Experimental Support For WebKit',    false
  end
end
