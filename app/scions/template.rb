module Template
  extend ScionBase

  def self.admin
    all.select { |template| template.end_with? '_admin' }
  end

  def self.regular
    all - admin
  end
end
