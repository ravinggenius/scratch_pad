require 'maruku'

module ApplicationHelper
  def page_id
    reply = "#{controller_name}_#{action_name}"
    reply = "#{reply}_#{h(params[:id]).to_i}" if params[:id]
    reply
  end

  def page_class
    "controller_#{controller_name} action_#{action_name}"
  end

  # http://www.leftrightdesigns.com/library/jquery/nospam/nospam.phps
  # contact//example/com
  #
  def obfuscate email, options = {}
    add_hints = options[:add_hints] || false
    filter_level = options[:filter_level] || :low

    email.reverse! if filter_level == :high

    email.gsub!(/[@]/, add_hints ? '<span class="hint" title="replace with commercial at (@)">//</span>' : '//')
    email.gsub!(/[\.]/, add_hints ? '<span class="hint" title="replace with period (.)">/</span>' : '/')

    email.html_safe
  end

  def filter text, options = {}
    options[:keep_paragraphs] = true unless options.key? :keep_paragraphs

    text = Maruku.new(text).to_html
    text.gsub! /<p>/, '' unless options[:keep_paragraphs]
    text.gsub! /<\/p>/, '' unless options[:keep_paragraphs]

    text.html_safe
  end

  def partial name, locals = {}, options = {}
    render options.merge(:partial => name.to_s, :locals => locals)
  end

  def show_node node, part
    path = "#{node.machine_name}/views/#{part}"
    path = "nodes/#{part}" unless template_exists? path, nil, true
    partial path, :node => node
  end
end
