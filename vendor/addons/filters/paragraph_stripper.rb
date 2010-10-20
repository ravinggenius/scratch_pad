module ParagraphStripper
  def self.process(string)
    string.gsub! /<p>/, ''
    string.gsub! /<\/p>/, ''
    string
  end
end
