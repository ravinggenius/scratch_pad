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

    email
  end

  def partial name, locals = {}
    render :partial => name.to_s, :locals => locals
  end
end
