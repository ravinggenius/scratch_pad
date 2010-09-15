module ApplicationHelper
  def page_id
    reply = "#{controller.controller_name}_#{controller.action_name}"
    reply = "#{reply}_#{h params[:id]}" if params[:id]
    reply
  end

  def page_classes
    page_class
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

  # Usage:
  # setting('core.templates.active')       #=> 'default'
  # setting('core.templates.active.admin') #=> 'default_admin'
  # setting('core.site.name')              #=> 'ScratchPad'
  # setting('core.site.tagline')           #=> '...'
  # setting('template.<name>.<some_setting>') #=> 3
  # setting('node_extension.<name>.<...>') #=> 'alternate'
  # TODO this method likely will require modification
  def setting(scope)
    Setting[scope].user_value rescue nil
  end
end
