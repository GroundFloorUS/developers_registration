module ApplicationHelper

  def us_states
    [
        ['AK', 'AK'],
        ['AL', 'AL'],
        ['AR', 'AR'],
        ['AZ', 'AZ'],
        ['CA', 'CA'],
        ['CO', 'CO'],
        ['CT', 'CT'],
        ['DC', 'DC'],
        ['DE', 'DE'],
        ['FL', 'FL'],
        ['GA', 'GA'],
        ['HI', 'HI'],
        ['IA', 'IA'],
        ['ID', 'ID'],
        ['IL', 'IL'],
        ['IN', 'IN'],
        ['KS', 'KS'],
        ['KY', 'KY'],
        ['LA', 'LA'],
        ['MA', 'MA'],
        ['MD', 'MD'],
        ['ME', 'ME'],
        ['MI', 'MI'],
        ['MN', 'MN'],
        ['MO', 'MO'],
        ['MS', 'MS'],
        ['MT', 'MT'],
        ['NC', 'NC'],
        ['ND', 'ND'],
        ['NE', 'NE'],
        ['NH', 'NH'],
        ['NJ', 'NJ'],
        ['NM', 'NM'],
        ['NV', 'NV'],
        ['NY', 'NY'],
        ['OH', 'OH'],
        ['OK', 'OK'],
        ['OR', 'OR'],
        ['PA', 'PA'],
        ['RI', 'RI'],
        ['SC', 'SC'],
        ['SD', 'SD'],
        ['TN', 'TN'],
        ['TX', 'TX'],
        ['UT', 'UT'],
        ['VA', 'VA'],
        ['VT', 'VT'],
        ['WA', 'WA'],
        ['WI', 'WI'],
        ['WV', 'WV'],
        ['WY', 'WY']
      ]
  end

  def simple_pluralize count, singular, plural=nil
    ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize))
  end

  def display_flash_messages(flash)
    return_data = ""
    return_data += success_message(flash[:notice]) if flash[:notice]
    return_data += warning_message(flash[:alert]) if flash[:alert]
    return_data += information_message(flash[:info]) if flash[:info]
    return_data += error_message(flash[:error], flash[:error_messages], flash[:pre_error_message]) if flash[:error]
    return raw(return_data)
  end

  def success_message(html)
    return raw("<div class='alert alert-success'>#{html}</div>") unless html.blank?
  end

  def warning_message(html)
    return raw("<div class='alert alert-error'>#{html}</div>") unless html.blank?
  end

  def information_message(html)
    return raw("<div class='alert alert-info'>#{html}</div>") unless html.blank?
  end

  def error_message(html, errors=nil, pre_error_message=nil)
    html += format_errors_hash(errors, pre_error_message) if errors
    return raw("<div class='alert alert-error'>#{html}</div>") unless html.blank?
  end

  def format_errors_hash(errors=nil, pre_error_message=nil)
    error_list = '<ul class="error_list">'
    errors.each do |e, m|
      if (pre_error_message)
        error_list += "<li>#{pre_error_message} #{"#{e}".humanize.downcase unless e == "base"} #{m}</li>"
      else
        error_list += "<li>#{"#{e}".humanize unless e == "base"} #{m}</li>"
      end
    end
    error_list += '</ul>'
  end
  
  def days_ago(date=nil)
    (Date.today - date).to_i
  end
  
end
