module ApplicationHelper
  def body_attributes
    page_id = "#{controller.controller_name}_#{controller.action_name}"
    page_id = "#{reply}_#{h params[:id]}" if params[:id]
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

  def filter(text, filter_group)
    Filter.process_all(text.to_s, filter_group).html_safe
  end

  def partial(name, locals = {}, options = {})
    render options.merge(:partial => name.to_s, :locals => locals)
  end

  def show_node(node, part, locals = {})
    path = "#{node.machine_name}/views/#{part}"
    path = "nodes/#{part}" unless template_exists? path, nil, true
    partial path, locals.merge(:node => node)
  end

  def show_widget(widget)
    render :file => "vendor/addons/widgets/#{widget.name}/views/_show"
  end

  def show_widgets(widgets)
    reply = ''
    widgets.each { |widget| reply << show_widget(widget) }
    reply.html_safe
  end

  def theme_tags(theme)
    reply = ''
    reply << stylesheet_link_tag(assets_styles_path(:theme => theme), :media => 'all')
    reply << javascript_include_tag(assets_scripts_path(:theme => theme))
    reply.html_safe
  end
end
