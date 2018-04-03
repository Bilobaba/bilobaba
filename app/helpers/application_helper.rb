module ApplicationHelper

  def capitalize_upcase(string)
    string.capitalize! if string == string.upcase
    return string
  end

  # every word in the text Upcase -> Capitalize
  def capitalize_text(text)
    strings = text.split(' ')
    strings.each do |s|
      s = capitalize_upcase(s)
    end
    return strings.join(' ')
  end

  # return the title for google map on 2 lines
  def map_title(title)
    tab = title.split(',')
    map_title = tab[0..tab.size-3].join(',') + "\n" + tab[tab.size-2..tab.size-1].join(',')
    return map_title
  end
end
