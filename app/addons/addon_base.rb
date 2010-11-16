class AddonBase
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def <=>(other)
    name <=> other.name
  end

  def enable
  end

  def disable
  end

  def title
    name.titleize
  end

  def purge
    disable
    # then clear configuration options
  end

  def path
    self.class.path + name
  end

  def glob(snip)
    Dir[path + snip]
  end

  def is_valid?
    !name.blank? && File.exists?(path)
  end

  def install
    []
  end

  def self.[](name)
    new name.to_s
  end

  def self.all
    reply = Dir.entries(path)
    reply.reject! { |entry| entry =~ /^\./ }
    reply.map! { |entry| new entry }
    reply.sort
  end

  def self.enabled
    all
  end

  def self.disabled
    []
  end

  def self.path
    Rails.root + 'vendor' + 'addons' + self.name.underscore.pluralize
  end

  def self.install
  end

  def self.register_setting(scope, name, default_value)
    setting = Setting.first_or_create :scope => scope
    setting.update_attributes :name => name, :value => default_value if setting.new?
  end
end
