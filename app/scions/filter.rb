class Filter < ScionBase
  def name
    super.gsub /\.rb/, ''
  end

  def filter
    @filter ||= name.camelize.constantize
  end

  def self.process_all(input, filter_group)
    filter_group.filters.each do |f|
      input = f.filter.process input
    end
    input
  end
end
