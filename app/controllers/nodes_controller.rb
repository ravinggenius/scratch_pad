class NodesController < ApplicationController
  def index
    @nodes = Node.published
    @featured = []
    @featured << @nodes.pop unless @nodes.empty?

    respond_to do |format|
      format.html
      format.xml { render :xml => @nodes }
    end
  end

  def show
    @node = Node.from_path(params[:path])

    if @node && @node.path.present? && (request.path != "/#{@node.path}")
      return redirect_to node_url(@node.to_path), :status => :moved_permanently
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @node }
    end
  end
end
