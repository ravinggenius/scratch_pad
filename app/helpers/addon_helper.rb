module AddonHelper
  def filter(text, filter_group)
    ScratchPad::Addon::Filter.process_all(text.to_s, filter_group).html_safe
  end

  def show_addon(addon, view = :show, locals = {})
    render :file => addon.find_view(view), :locals => locals
  end

  def show_node(node, part, locals = {})
    locals.merge! :node => node

    if node.class.machine_name == 'node'
      render :file => "nodes/#{part}", :locals => locals
    else
      show_addon ScratchPad::Addon::NodeExtension[node.class.machine_name], part, locals
    end
  end

  def show_node_children(children)
    reply = ''
    children.each do |child|
      reply << wrap_node(child, :showing_part => :full)
    end
    reply.html_safe
  end

  def wrap_node(node, wrapper = :article, options = {})
    if wrapper.is_a? Hash
      options = wrapper
      wrapper = options[:wrapper] || :article
    end

    is_featured = options[:is_featured] || false
    is_single = options[:is_single] || false
    showing_part = options[:showing_part] || ((is_featured || is_single) ? :full : :preview)

    wrapper_classes = [
      :node,
      node.class.machine_name,
      showing_part,
      (:featured if is_featured)
    ].compact.map(&:to_s).map(&:dasherize)

    attrs = {
      :id => "node_#{node.id}",
      :class => wrapper_classes
    }

    [
      "<#{wrapper} #{hash_to_attrs(attrs)}>",
      show_node(node, showing_part),
      "</#{wrapper}>"
    ].map { |snip| snip.present? ? snip : nil }.compact.join "\n"
  end

  def show_region(region)
    reply = ''

    if region
      name = region.name.underscore

      if region.wrapper
        region_start = "<#{region.wrapper} #{hash_to_attrs(:id => name)}>"
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
    [
      stylesheet_link_tag(assets_styles_path(theme.machine_name), :media => :all),
      javascript_include_tag(assets_scripts_path(theme.machine_name))
    ].join "\n"
  end

  def assets_image_path(addon, path)
    assets_static_path addon.addon_type.machine_name, addon.machine_name, :images, path
  end
end
