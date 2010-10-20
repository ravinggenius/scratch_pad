module MarukuFilter
  def self.process(string)
    Maruku.new(string).to_html
  end
end
