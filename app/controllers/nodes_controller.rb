class NodesController < ApplicationController
  def index
    @nodes = Node.published
    @featured = []
    @featured << @nodes.pop unless @nodes.empty?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nodes }
    end
  end

  def show
    @node = Node.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @node }
    end
  end
end
