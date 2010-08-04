class Filter < ScionBase
  def name
    super.gsub /\.rb/, ''
  end

  def self.process_all(input, filter_group)
    filter_group.filters.each do |f|
      f = f.camelize.constantize
      input = f.process input
    end
    input
  end

  def self.to_mongo(value)
    value.name
  end

  def self.from_mongo(value)
    new "#{value}.rb"
  end
end
