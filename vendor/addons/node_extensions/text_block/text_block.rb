module NodeExtensions
  class TextBlock < ScratchPad::Addon::NodeExtension
    class Model < ScratchPad::Addon::NodeExtension::ModelBase
      key :data, String, :required => true
    end
  end
end
