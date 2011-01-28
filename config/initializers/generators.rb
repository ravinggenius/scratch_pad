Rails.application.config.generators do |g|
  g.orm = :mongo_mapper
  g.template_engine = :haml
  g.test_framework = :rspec
  g.fixture_replacement :factory_girl
end
