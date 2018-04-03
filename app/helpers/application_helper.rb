module ApplicationHelper

  def capitalize_upcase(string)
    string.capitalize! if string == string.upcase
    return string
  end

  def capitalize_text(text)
    strings = text.split(' ')
    strings.each do |s|
      s = capitalize_upcase(s)
    end
    return strings.join(' ')
  end
end
