MongoMapper.config = {
  Rails.env => {
    'uri' => (ENV['MONGOHQ_URL'] ? ENV['MONGOHQ_URL'] : 'mongodb://localhost/scratchpad')
  }
}

MongoMapper.connect(Rails.env)
