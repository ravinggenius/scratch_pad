class ScratchPad::Addon::NodeExtension
  class ModelBase < Node
    def self.title
      name.scan /^NodeExtensions::(.*)::Model$/
      $1
    end
  end
end
