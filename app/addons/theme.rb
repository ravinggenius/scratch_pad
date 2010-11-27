class Theme < AddonBase
  def self.admin?
    machine_name.end_with? '_admin'
  end

  def self.frontend
    all.reject { |theme| theme.admin? }
  end

  def self.backend
    all.select { |theme| theme.admin? }
  end

  def self.install
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
