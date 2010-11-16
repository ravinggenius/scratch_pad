class DoNothing < Filter
  def self.process(string)
    string
  end
end
