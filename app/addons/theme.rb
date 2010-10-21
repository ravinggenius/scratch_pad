class Theme < AddonBase
  def admin?
    name.end_with? '_admin'
  end

  def self.admin
    all.select { |theme| theme.admin? }
  end

  def self.regular
    all.select { |theme| theme.admin? }
  end
end
