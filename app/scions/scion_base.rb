class ScionBase
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def enable
  end

  def disable
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

  def self.[](name)
    new name
  end

  def self.all
    reply = Dir.entries(path)
    reply.reject! { |entry| entry =~ /^\./ }
    reply.map! { |entry| new entry }
    reply
  end

  def self.enabled
    all
  end

  def self.disabled
    []
  end

  def self.path
    Rails.root + 'vendor' + 'scions' + self.name.underscore.pluralize
  end
end
