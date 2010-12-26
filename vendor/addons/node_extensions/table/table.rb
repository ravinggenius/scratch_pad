class Table < NodeExtension
  class Model < NodeExtension::Model
    key :data, Array, :required => true
    key :has_header_row, Boolean, :required => true, :default => false
  end
end
