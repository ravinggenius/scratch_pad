class Pathname
  def extensionless
    path = to_path
    self.class.new(path[0...(path.length - extname.length)])
  end
end
