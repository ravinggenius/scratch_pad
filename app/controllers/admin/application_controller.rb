class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter do
    @active_node_extensions = []
  end
end
