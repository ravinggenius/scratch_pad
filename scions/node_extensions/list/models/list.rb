class List < Node
  key :items, Array

  validates_presence_of :items
end
