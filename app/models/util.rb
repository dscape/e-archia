class Util < ActiveRecord::Base
  # this makes no sense whatsoever but i dont fucking care
  # ==========================================================================
  # class methods
  # ==========================================================================  
  def self.timeago(time)
    start_date = Time.now
    date_format = :default
    dif = start_date.to_i - time.to_i
    delta_minutes = dif.floor / 60
    if delta_minutes.abs <= (8724*60) 
      distance = distance_of_time_in_words(delta_minutes);
      if delta_minutes < 0
        "dentro de #{distance}"
      else
        "à #{distance} atrás"
      end
    else
      return "em #{time.to_formatted_s(date_format)}"
    end
  end

  def self.distance_of_time_in_words(minutes)
    case
      when minutes < 1
        "menos de um minuto"
      when minutes < 50
        pluralize(minutes, "minuto")
      when minutes < 90
        "cerca de uma hora"
      when minutes < 1080
        "#{(minutes / 60).round} horas"
      when minutes < 1440
        "um dia"
      when minutes < 2880
        "cerca de um dia"
      else
        "#{(minutes / 1440).round} dias"
    end
  end
  
  def self.pluralize(num,word)
    if num<=1 && num>=-1
      num.to_s + ' ' + word
    else
      num.to_s + ' ' + Inflector.pluralize(word)
    end
  end
end
