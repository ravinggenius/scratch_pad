if ENV['MONGOHQ_URL']
  MongoMapper.config = {Rails.env => {'uri' => ENV['MONGOHQ_URL']}}
else
  MongoMapper.config = {Rails.env => {'uri' => 'mongodb://localhost/scratchpad'}}
end

MongoMapper.connect(Rails.env)
