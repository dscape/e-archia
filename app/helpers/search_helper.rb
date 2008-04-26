module SearchHelper
  def render_text(text)
    show = text.split[0..130].join(' ')
    if(show == text)
      text
    else
      show + ' (...)'
    end
  end
end
