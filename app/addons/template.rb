class Template < AddonBase
  def admin?
    name.end_with? '_admin'
  end

  def self.admin
    all.select { |template| template.admin? }
  end

  def self.regular
    all.select { |template| !template.admin? }
  end
end
