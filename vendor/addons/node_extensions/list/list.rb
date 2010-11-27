class List < NodeExtension
  class Model < Node
    key :items, Array

    validates_presence_of :items
  end
end
