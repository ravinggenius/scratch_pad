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
  # contact//305online/net
  #
  def obfuscate email_address, options = {}
    email = email_address
    add_hints = options[:add_hints] || false
    filter_level = options[:filter_level] || :low

    email.gsub!(/[@]/, add_hints ? '<span class="hint" title="replace with commercial at (@)">//</span>' : '//')
    email.gsub!(/[\.]/, add_hints ? '<span class="hint" title="replace with period (.)">/</span>' : '/')

    email.reverse! if filter_level == :high

    email.html_safe
  end

  def filter text, options = {}
    options[:keep_paragraphs] = true unless options.key? :keep_paragraphs

    text = Maruku.new(text).to_html
    text.gsub! /<p>/, '' unless options[:keep_paragraphs]
    text.gsub! /<\/p>/, '' unless options[:keep_paragraphs]

    text.html_safe
  end

  # FIXME: incorporate the options hash
  def partial name, locals = {}, options = {}
    #options.merge! locals
    #options[:partial] = name.to_s
    #render options

    render :partial => name.to_s, :locals => locals
  end

  def show_node node, part
    path = "#{node.machine_name}/views/#{part}"
    path = "nodes/#{part}" unless template_exists? path, nil, true
    partial path, :node => node
  end
end
