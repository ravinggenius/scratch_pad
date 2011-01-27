class Admin::NodesController < Admin::ApplicationController
  respond_to :html, :json

  before_filter do
    @parent = Node.find params[:parent_id]
  end

  def index
    @nodes = @parent ? @parent.children : Node.sort(:created_at).all

    respond_with @nodes
  end

  def new
    @node = node_type.new
    @selected_node_type = node_type.machine_name
    set_fieldset_ivars

    respond_with do |format|
      format.html { render 'shared/edit_new' }
    end
  end

  def edit
    @node = node_type.find params[:id]
    set_fieldset_ivars
    render 'shared/edit_new'
  end

  def create
    @node = node_type.new params[:node]
    @node.parse_terms (params[:vocabularies] || {})

    respond_to do |format|
      if @node.save
        if @parent
          @parent.children << @node
          @parent.save
        end
        format.html { redirect_to(admin_nodes_url, :notice => "#{@node.class.title} was successfully created.") }
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
    @node.parse_terms (params[:vocabularies] || {})

    respond_to do |format|
      if @node.update_attributes(params[:node])
        if @parent
          @parent.children << @node
          @parent.save
        end
        format.html { redirect_to(admin_nodes_url, :notice => "#{@node.class.title} was successfully updated.") }
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

    respond_with @node do |format|
      format.html { redirect_to admin_nodes_url }
    end
  end

  def new_node_type
    set_vocabulary_ivars
    render :partial => 'node_extension_fieldsets', :locals => { :node => node_type.new }
  end

  private

  def node_type
    @nt ||= lambda do |selected|
      return Node if selected == 'node'
      ScratchPad::Addon::NodeExtension.enabled.map(&:machine_name).include?(selected) ? ScratchPad::Addon::NodeExtension[selected]::Model : Node
    end.call params[:node_type]
    @nt
  end

  def set_fieldset_ivars
    if @node.new?
      @node_types = ScratchPad::Addon::NodeExtension.enabled.map do |extension|
        [extension.title, extension.machine_name]
      end.sort.insert 0, ['Node', 'node']
    end

    @node_states = Node::STATES.map { |state| [state, state] }

    @filter_groups = FilterGroup.all.sort_by &:name

    set_vocabulary_ivars
  end

  def set_vocabulary_ivars
    vocabularies = Vocabulary.all
    node_is_plain = node_type.machine_name == 'node'

    # TODO allow plain Nodes to use taxonomy
    @grouped_vocabularies = {}
    @grouped_vocabularies[:required] = vocabularies.select { |v| v.node_types_required.include? ScratchPad::Addon::NodeExtension[node_type.title] unless node_is_plain }
    @grouped_vocabularies[:optional] = vocabularies.select { |v| v.node_types_optional.include? ScratchPad::Addon::NodeExtension[node_type.title] unless node_is_plain } - @grouped_vocabularies[:required]
  end
end
