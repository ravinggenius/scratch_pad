class String
  def truthy?
    %w[ 1 on t true y yes ].include? downcase
  end
end
