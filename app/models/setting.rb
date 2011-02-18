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

  def self.all_in_scope(*scope)
    all :scope => /^#{scope.join SCOPE_GLUE}/
  end

  def self.global_settings
    s = Struct.new :scope, :name, :value

   [
      s.new([:site, :name],                  'Site Name',                          'ScratchPad'),
      s.new([:site, :tagline],               'Site Tagline',                       '...'),
      s.new([:user, :password, :min_length], 'Minimum Password Length',            8),
      s.new([:theme, :frontend],             'Frontend Theme',                     :default),
      s.new([:theme, :backend],              'Backend Theme',                      :default_admin),
      s.new([:theme, :support, :khtml],      'Experimental Support For KHTML',     false),
      s.new([:theme, :support, :microsoft],  'Experimental Support For Microsoft', false),
      s.new([:theme, :support, :mozilla],    'Experimental Support For Mozilla',   false),
      s.new([:theme, :support, :opera],      'Experimental Support For Opera',     false),
      s.new([:theme, :support, :svg],        'Experimental Support For SVG',       true),
      s.new([:theme, :support, :webkit],     'Experimental Support For WebKit',    false)
    ] 
  end

  def self.parse_string_for_global_settings(phrase)
    keys = {}
    global_settings.each { |s| keys[s.scope.join('_').to_sym] = self[s.scope] }
    phrase % keys
  end

  private

  def self.load_scope(*scope)
    Setting.first(:scope => scope.join(SCOPE_GLUE))
  end
end
