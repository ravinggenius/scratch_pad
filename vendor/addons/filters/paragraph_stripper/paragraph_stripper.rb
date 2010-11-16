class ParagraphStripper < Filter
  def self.process(string)
    string.gsub! /<p>/, ''
    string.gsub! /<\/p>/, ''
    string
  end
end
