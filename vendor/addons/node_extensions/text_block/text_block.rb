class TextBlock < NodeExtension
  class Model < NodeExtension::Model
    key :data, String, :required => true
  end
end
