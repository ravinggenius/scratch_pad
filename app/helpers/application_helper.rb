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

  def show_region(region)
    reply = ''

    if region
      name = region.name.underscore

      if region.wrapper
        region_start = "<#{region.wrapper} id=\"#{name}\">"
        region_end = "</#{region.wrapper}><!-- ##{name} -->"
      else
        region_start = "<!-- #{name} start -->"
        region_end = "<!-- #{name} end -->"
      end

      reply = [
        region_start,
        region.widgets.map { |widget| show_addon(widget).strip }.join("\n").strip,
        region_end
      ].map { |snip| snip.present? ? snip : nil }.compact.join "\n"
    end

    reply.html_safe
  end

  def theme_tags(theme)
    theme_name = theme.respond_to?(:machine_name) ? theme.machine_name : theme
    reply = ''
    reply << stylesheet_link_tag(assets_styles_path(:theme => theme_name), :media => 'all')
    reply << javascript_include_tag(assets_scripts_path(:theme => theme_name))
    reply.html_safe
  end

  # TODO find a way to make this work
  def classy_html_tags(options = {})
    html_options = ''
    options.each { |attribute, value| html_options << " #{attribute}=\"#{value}\"" }
    html_open = <<-HTML
<!--[if lt IE 7]>              <html#{html_options} class="no-js ie ie6 lte9 lte8 lte7 lte6"> <![endif]-->
<!--[if IE 7]>                 <html#{html_options} class="no-js ie ie7 lte9 lte8 lte7">      <![endif]-->
<!--[if IE 8]>                 <html#{html_options} class="no-js ie ie8 lte9 lte8">           <![endif]-->
<!--[if IE 9]>                 <html#{html_options} class="no-js ie ie9 lte9">                <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html#{html_options} class="no-js">                        <!--<![endif]-->
    HTML
    html_close = '</html>'
  end
end
