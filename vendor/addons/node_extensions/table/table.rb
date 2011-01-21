module NodeExtensions
  class Table < ScratchPad::Addon::NodeExtension
    class Model < ScratchPad::Addon::NodeExtension::ModelBase
      key :data, Array, :required => true
      key :has_header_row, Boolean, :required => true, :default => false
    end
  end
end
