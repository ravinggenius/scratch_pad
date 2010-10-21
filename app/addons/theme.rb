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
end
