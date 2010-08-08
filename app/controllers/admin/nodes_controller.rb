class Admin::NodesController < Admin::ApplicationController
  def index
    @nodes = Node.sort(:created_at).all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @nodes }
    end
  end

  #def show
  #  @node = node_type.find params[:id]

  #  respond_to do |format|
  #    format.html
  #    format.xml  { render :xml => @node }
  #  end
  #end

  def new
    @node = node_type.new
    set_fieldset_ivars

    respond_to do |format|
      format.html
      format.xml  { render :xml => @node }
    end
  end

  def edit
    @node = node_type.find params[:id]
    set_fieldset_ivars
  end

  def create
    @node = node_type.new params[:node]

    respond_to do |format|
      if @node.save
        format.html { redirect_to(admin_nodes_url, :notice => "#{node_type.name} was successfully created.") }
        format.xml  { render :xml => @node, :status => :created, :location => node_url(@node) }
      else
        set_fieldset_ivars
        format.html { render :action => 'new' }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @node = node_type.find params[:id]
    #@node.set(:_type => params[:node_type].camelize) if NodeExtension[params[:node_type]].is_valid?

    respond_to do |format|
      if @node.update_attributes(params[:node])
        format.html { redirect_to(admin_nodes_url, :notice => "#{node_type.name} was successfully updated.") }
        format.xml  { head :ok }
      else
        set_fieldset_ivars
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @node = Node.find params[:id]
    @node.destroy

    respond_to do |format|
      format.html { redirect_to admin_nodes_url }
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

  def set_fieldset_ivars
    if @node.may_convert?
      @node_types = NodeExtension.enabled.map { |extension| [extension.title, extension.name] }.insert 0, ['Node', 'node']
      @selected_node_type = params[:node_type] || @node.machine_name
    end
    @filter_groups = FilterGroup.all.sort_by &:name
  end
end
