module NodeExtensions
  class Page < ScratchPad::Addon::NodeExtension
    class Model < ScratchPad::Addon::NodeExtension::ModelBase
      key :slug, String
    end
  end
end
