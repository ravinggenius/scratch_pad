module ScionBase
  def all
    Dir.entries(Rails.root + 'scions' + path).delete_if { |entry| entry =~ /^\./ }
  end

  private

  def path
    self.name.underscore.pluralize
  end
end
