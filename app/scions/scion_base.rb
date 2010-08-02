class ScionBase
  def enable
  end

  def disable
  end

  def self.all
    Dir.entries(path).delete_if { |entry| entry =~ /^\./ }
  end

  def self.[](glob)
    Dir[path + glob]
  end

  def self.path
    Rails.root + 'vendor' + 'scions' + self.name.underscore.pluralize
  end
end
