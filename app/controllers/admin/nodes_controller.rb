class Admin::NodesController < Admin::ApplicationController
  def index
    @nodes = Node.sort(:created_at).all

    respond_to do |format|
      format.html
      format.xml { render :xml => @nodes }
    end
  end

  def new
    @node = node_type.new
    set_fieldset_ivars

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @node }
    end
  end

  def edit
    @node = node_type.find params[:id]
    set_fieldset_ivars
    render 'shared/edit_new'
  end

  def create
    @node = node_type.new params[:node]

    respond_to do |format|
      if @node.save
        format.html { redirect_to(admin_nodes_url, :notice => "#{node_type.name} was successfully created.") }
        format.xml { render :xml => @node, :status => :created, :location => node_url(@node) }
      else
        set_fieldset_ivars
        format.html do
          flash[:error] = @node.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @node = node_type.find params[:id]

    respond_to do |format|
      if @node.update_attributes(params[:node])
        format.html { redirect_to(admin_nodes_url, :notice => "#{node_type.name} was successfully updated.") }
        format.xml { head :ok }
      else
        set_fieldset_ivars
        format.html do
          flash[:error] = @node.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @node = Node.find params[:id]
    @node.destroy

    respond_to do |format|
      format.html { redirect_to admin_nodes_url }
      format.xml { head :ok }
    end
  end

  def new_node_type
    render :partial => 'node_extension_fieldset', :locals => { :node => node_type.new }
  end

  private

  def node_type
    @n ||= begin
      ne = NodeExtension[params[:node_type]]
      raise 'Invalid Node Extension' unless NodeExtension.enabled.include? ne
      ne::Model
    rescue
      Node
    end
  end

  def set_fieldset_ivars
    if @node.new?
      @node_types = NodeExtension.enabled.map do |extension|
        [extension.name.titleize, extension.machine_name]
      end.insert 0, ['Node', 'node']
      ne = NodeExtension[params[:node_type]]
      @selected_node_type = NodeExtension.enabled.include?(ne) ? ne.machine_name : @node.class.machine_name
    end
    @filter_groups = FilterGroup.all.sort_by &:name
  end
end
