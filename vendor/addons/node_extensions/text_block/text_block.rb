class TextBlock < NodeExtension
  class Model < Node
    key :data, String, :required => true
  end
end
