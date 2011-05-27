mongo_url = case
when ENV['MONGOHQ_URL']
  ENV['MONGOHQ_URL']
when (db_file = Rails.root + 'config' + 'database.yml').file?
  db = YAML.load_file(db_file)[Rails.env]
  port = db['port'].nil? ? '' : ":#{db['port']}"
  "mongodb://#{db['host']}#{port}/#{db['database']}"
else
  raise "Could not find MongoDB URI! You might need to create #{db_file}"
end

MongoMapper.config = { Rails.env => { 'uri' => mongo_url } }
MongoMapper.connect(Rails.env)
