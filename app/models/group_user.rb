class GroupUser
  include MongoMapper::Document
  include Relationship

  habtm_glue :group, :user
end
