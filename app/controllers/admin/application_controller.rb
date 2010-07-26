class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter do
    @active_node_extensions = available_node_extensions
  end

  private

  def available_node_extensions
    @available_node_extensions ||= (Dir.entries Rails.root + 'lib' + 'node_extensions').delete_if { |entry| entry =~ /^\./ }
  end
end
