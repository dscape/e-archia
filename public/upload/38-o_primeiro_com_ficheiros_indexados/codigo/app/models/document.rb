require 'set'
    
class Document < ActiveRecord::Base
  has_many :words
  before_save  :remove_punctuation
  after_create :create_index
  
  def self.find_all(phrase)
    not_list = []
    and_list = []
    
    phrase.split.each do |w| 
      if w.starts_with?('-')
         not_list << Word.find_all_that_contain(w.gsub('-','').downcase)
      else 
         and_list << Word.find_all_that_contain(w.downcase)
      end
    end
    
    sort_results and_list, not_list
  end

  private
  
  def self.sort_results(and_list,not_list)
    not_ids = not_list.map { |e| e.first }.flatten
    
    # codigo adaptado do blog de miguelregedor.com
    x = and_list.map {|a| a.map {|a| a.first } }
    contagem = {}
    x.flatten.each { |e| contagem[e].nil? ? contagem[e] = 1 : contagem[e] = contagem[e] + 1 }
    
    lh = []
    ll = []
    
    contagem.each_pair { |k,v| v == and_list.size ? lh << [k,v] : ll << [k,v] }
    
    ordenacao_high = lh.sort_by { |a| a[1] }.reverse.map {|x,v| x}
    ordenacao_low  = ll.sort_by { |a| a[1] }.reverse.map {|x,v| x}
    
    resultado = (ordenacao_high + ordenacao_low).select { |e| !not_ids.member? e }
  end
  
  def create_index
    h = {}
    
    contents.each { |l| l.split.each { |w| w.downcase!; w.size > 2 and h[w].nil? ? h[w] = 1 : h[w] = h[w] + 1 } }
    
    h.each_pair do |key, value| 
      Word.create(:word => key, :document => id, :weight => value)
    end
  end
  
  def remove_punctuation
    self.contents = self.contents.map { |c| c.gsub(/[^a-zA-Z ]/, ' ') }
  end
end
