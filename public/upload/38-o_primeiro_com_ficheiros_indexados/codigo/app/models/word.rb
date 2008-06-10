class Word < ActiveRecord::Base
  belongs_to :document

  def self.find_all_that_contain(word)
    s = Set.new
    (Word.find :all).each { |r| s << [r.document.id, r.weight] if r.word == word }
    s.sort_by { |a| a[1] }.reverse
  end

end
