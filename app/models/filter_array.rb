class FilterArray < Array
  def self.to_mongo(values)
    values ||= []
    values.map { |v| v.respond_to?(:name) ? v.name : v }
  end

  def self.from_mongo(values)
    values ||= []
    values.map { |v| v.respond_to?(:name) ? v : Filter["#{v}.rb"] }
  end
end
