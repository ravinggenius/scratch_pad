module ApplicationHelper
  def body_attributes
    page_id = "#{controller.controller_name}_#{controller.action_name}"
    page_id = "#{page_id}_#{h params[:id]}" if params[:id]
    { :id => page_id, :class => page_class }
  end

  # http://www.leftrightdesigns.com/library/jquery/nospam/nospam.phps
  # contact//example/com
  #
  def obfuscate(email, options = {})
    add_hints = options[:add_hints] || false
    filter_level = options[:filter_level] || :low

    email.reverse! if filter_level == :high

    email.gsub!(/[@]/, add_hints ? '<span class="hint" title="replace with commercial at (@)">//</span>' : '//')
    email.gsub!(/[\.]/, add_hints ? '<span class="hint" title="replace with period (.)">/</span>' : '/')

    email.html_safe
  end

  def options_from_collection_for_select(collection, value_method, text_method, options = {})
    include_blank = options[:include_blank] || false
    selected = options[:selected] || nil
    reply = ''
    if include_blank
      blank_text = include_blank.is_a?(String) ? include_blank : ''
      reply << "<option>#{blank_text}</option>"
    end
    reply << super(collection, value_method, text_method, selected)
    reply.html_safe
  end

  def filter(text, filter_group)
    Filter.process_all(text.to_s, filter_group).html_safe
  end

  def dump_children(node)
    render :partial => 'nodes/article', :collection => node.children, :as => :node, :locals => { :showing_part => :full }
  end

  def show_addon(addon, view = :show, locals = {})
    render :file => addon.views + view.to_s, :locals => locals
  end

  def show_node(node, part, locals = {})
    show_addon NodeExtension[node.class.machine_name], part, locals.merge(:node => node)
  end

  def show_widgets(widgets)
    reply = ''
    widgets.each { |widget| reply << show_addon(widget) }
    reply.html_safe
  end

  def theme_tags(theme)
    reply = ''
    reply << stylesheet_link_tag(assets_styles_path(:theme => theme), :media => 'all')
    reply << javascript_include_tag(assets_scripts_path(:theme => theme))
    reply.html_safe
  end
end
