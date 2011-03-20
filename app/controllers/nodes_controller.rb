class NodesController < ApplicationController
  respond_to :html, :json

  def index
    @nodes = Node.published
    @featured = []
    @featured << @nodes.pop unless @nodes.empty?

    respond_with @nodes
  end

  # GET /nodes/4d1a44571d41c821eb000008.json
  # GET /nodes/4d1a44571d41c821eb000008.#{custom_extension} # custom formats are expected to be handled by the specific node extension that generate them
  # HTML request get redirected to human_node_url
  def show
    @node = Node.find params[:id]

    raise HTTPStatuses::NotFound unless @node.present?

    # if extension is present and is in html_extensions list, redirect to human_node_url
    if html_extensions.include? current_extension
      return redirect_to human_node_url(@node.to_path), :status => :moved_permanently
    end

    respond_with @node
  end

  # GET /about
  # GET /about/us
  # GET /about/us.html
  # GET /4d1a44571d41c821eb000008
  # GET /4d1a44571d41c821eb000008.(x)htm(l)
  # non-HTML requests are redirected to node_url
  def show_human
    # if extension is present and is NOT in html_extensions list, redirect to node_url
    if html_extensions.include? current_extension
      @node = Node.from_path params[:path]
      @node = Node.from_path extensionless_path(params[:path]) unless @node.present?

      raise HTTPStatuses::NotFound unless @node.present?

      if @node.path.present? && (request.path != '/') && (request.path != "/#{@node.path}")
        return redirect_to human_node_url(@node.to_path), :status => :moved_permanently
      end
    else
      node = Node.from_path extensionless_path(params[:path])
      return redirect_to node_url(node, current_extension), :status => :moved_permanently
    end

    render :action => :show
  end

  private

  def current_extension
    @current_extension ||= Pathname.new(request.path).extname.sub '.', ''
  end

  def extensionless_path(path)
    Pathname.new(path).extensionless.to_s
  end

  def html_extensions
    %w[ htm html xhtml ] << ''
  end
end
