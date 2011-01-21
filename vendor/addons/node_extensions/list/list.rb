module NodeExtensions
  class List < ScratchPad::Addon::NodeExtension
    class Model < ScratchPad::Addon::NodeExtension::ModelBase
      key :items, Array

      validates_presence_of :items
    end
  end
end
