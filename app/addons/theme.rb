class Theme < AddonBase
  def admin?
    name.end_with? '_admin'
  end

  def self.frontend
    all.reject { |theme| theme.admin? }
  end

  def self.backend
    all.select { |theme| theme.admin? }
  end

  def self.install
    [
      { :scope => 'addon.theme.frontend',          :name => 'Frontend Theme',                     :value => :default },
      { :scope => 'addon.theme.backend',           :name => 'Backend Theme',                      :value => :default_admin },
      { :scope => 'addon.theme.support.khtml',     :name => 'Experimental Support For KHTML',     :value => false },
      { :scope => 'addon.theme.support.microsoft', :name => 'Experimental Support For Microsoft', :value => false },
      { :scope => 'addon.theme.support.mozilla',   :name => 'Experimental Support For Mozilla',   :value => false },
      { :scope => 'addon.theme.support.opera',     :name => 'Experimental Support For Opera',     :value => false },
      { :scope => 'addon.theme.support.webkit',    :name => 'Experimental Support For WebKit',    :value => false }
    ]
  end
end
