class Admin::NodesController < Admin::ApplicationController
  before_filter do
    @parent = Node.find params[:parent_id]
  end

  def index
    @nodes = @parent ? @parent.children : Node.sort(:created_at).all

    respond_to do |format|
      format.html
      format.xml { render :xml => @nodes }
    end
  end

  def new
    @node = node_type.new
    @selected_node_type = node_type.machine_name
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
    vocabularies = params[:node].delete(:vocabularies) || {}
    @node = node_type.new params[:node]

    @node.parse_terms vocabularies

    respond_to do |format|
      if @node.save
        if @parent
          @parent.children << @node
          @parent.save
        end
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
    vocabularies = params[:node].delete(:vocabularies) || {}
    @node = node_type.find params[:id]

    @node.parse_terms vocabularies

    respond_to do |format|
      if @node.update_attributes(params[:node])
        if @parent
          @parent.children << @node
          @parent.save
        end
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
    @nt ||= lambda do |selected|
      return Node if selected == 'node'
      NodeExtension.enabled.map(&:machine_name).include?(selected) ? NodeExtension[selected]::Model : Node
    end.call params[:node_type]
    @nt
  end

  def set_fieldset_ivars
    if @node.new?
      @node_types = NodeExtension.enabled.map do |extension|
        [extension.name, extension.machine_name]
      end.sort.insert 0, ['Node', 'node']
    end

    @filter_groups = FilterGroup.all.sort_by &:name

    vocabularies = Vocabulary.all
    @required_vocabularies = vocabularies.select { |v| v.node_types_required.include? NodeExtension[@node.class.title] }
    @optional_vocabularies = vocabularies.select { |v| v.node_types_optional.include? NodeExtension[@node.class.title] } - @required_vocabularies
  end
end
