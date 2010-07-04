class GroupUser
  include MongoMapper::Document
  extend Relationship

  key :group_id, String, :required => true
  key :user_id, String, :required => true

  habtm_glue :group, :node
end
