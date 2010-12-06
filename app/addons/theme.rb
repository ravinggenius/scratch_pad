class Theme < AddonBase
  def self.admin?
    machine_name.end_with? '_admin'
  end

  def self.frontend
    enabled.reject { |theme| theme.admin? }
  end

  def self.backend
    enabled.select { |theme| theme.admin? }
  end

  def self.frontend?
    Theme.frontend.include? self
  end

  def self.backend?
    Theme.backend.include? self
  end
end
