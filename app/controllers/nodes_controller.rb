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

  def new
    @node = Node.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @node }
    end
  end

  def edit
    @node = Node.find(params[:id])
  end

  def create
    @node = node_type.new params[:node]

    respond_to do |format|
      if @node.save
        format.html { redirect_to(@node, :notice => "#{node_type.name} was successfully created.") }
        format.xml  { render :xml => @node, :status => :created, :location => @node }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @node = node_type.find(params[:id])

    respond_to do |format|
      if @node.update(params[:node])
        format.html { redirect_to(@node, :notice => "#{node_type.name} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to(nodes_url) }
      format.xml  { head :ok }
    end
  end

  private

  def node_type
    @n ||= begin
      params[:node_type].camelize.constantize
    rescue
      Node
    end
  end
end
