file_name = Rails.root + 'config' + 'database.yml'

if File.exists? file_name
  y = YAML.load_file(file_name)[Rails.env]
  mongo_url = "mongodb://#{y['host']}#{y['port'].nil? ? '' : ":#{y['port']}"}/#{y['database']}" # 'ongodb://localhost/scratch_pad
end

MongoMapper.config = {
  Rails.env => {
    'uri' => (ENV['MONGOHQ_URL'] ? ENV['MONGOHQ_URL'] : mongo_url)
  }
}

MongoMapper.connect(Rails.env)
