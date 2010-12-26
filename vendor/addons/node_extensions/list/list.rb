class List < NodeExtension
  class Model < NodeExtension::Model
    key :items, Array

    validates_presence_of :items
  end
end
