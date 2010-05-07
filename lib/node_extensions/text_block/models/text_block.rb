class TextBlock < Node
  key :data, Text

  validates_presence_of :data
end
