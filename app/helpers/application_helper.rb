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
    line_1 = tab[0..tab.size-3].join(',')
    line_2 = tab[tab.size-2..tab.size-1].join(',')
    return [line_1,line_2]
  end

  def date_sum(time)
     date_sum = I18n.l(time, format: '%-d %B %Y')
     return date_sum
  end
end
