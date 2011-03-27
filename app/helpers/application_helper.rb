module ApplicationHelper
  def body_attributes
    page_id = "#{controller.controller_name}_#{controller.action_name}"
    page_id = "#{page_id}_#{h params[:id]}" if params[:id]
    { :id => page_id, :class => page_class }
  end

  def hash_to_attrs(hash)
    #Haml::Compiler.build_attributes false, '"', :once, hash

    spaced_out = [:class]
    hash.map do |attribute, value|
      value = value.join ' ' if spaced_out.include?(attribute) && value.is_a?(Array)
      "#{attribute}=\"#{value}\""
    end.join ' '
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

  def classy_html_tags(element_name, attributes = {}, should_compress = :production, &content)
    html_open = if Setting[:theme, :support, :microsoft].truthy?
      <<-HTML
<!--[if lt IE 7]>              <#{element_name} #{hash_to_attrs attributes.merge(:class => %w[no-js ie ie6 lte9 lte8 lte7 lte6])}> <![endif]-->
<!--[if IE 7]>                 <#{element_name} #{hash_to_attrs attributes.merge(:class => %w[no-js ie ie7 lte9 lte8 lte7])}>      <![endif]-->
<!--[if IE 8]>                 <#{element_name} #{hash_to_attrs attributes.merge(:class => %w[no-js ie ie8 lte9 lte8])}>           <![endif]-->
<!--[if IE 9]>                 <#{element_name} #{hash_to_attrs attributes.merge(:class => %w[no-js ie ie9 lte9])}>                <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <#{element_name} #{hash_to_attrs attributes.merge(:class => %w[no-js])}>                        <!--<![endif]-->
      HTML
    else
      "<#{element_name} #{hash_to_attrs attributes.merge(:class => %w[no-js])}>"
    end
    if should_compress
      html_open.gsub! /\s+/, ' ' unless should_compress.is_a?(Symbol) && !Rails.env.send(should_compress.to_s + '?')
    end
    surround html_open, "</#{element_name}>", &content
  end
end
