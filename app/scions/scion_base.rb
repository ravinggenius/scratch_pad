module ScionBase
  def all
    Dir.entries(path).delete_if { |entry| entry =~ /^\./ }
  end

  def [](glob)
    Dir[path + glob]
  end

  def path
    Rails.root + 'vendor' + 'scions' + self.name.underscore.pluralize
  end
end
