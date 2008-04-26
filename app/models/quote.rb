# ============================================================================
# e-archia: quote model
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class Quote < ActiveRecord::Base
  # ==========================================================================
  # data validation
  # ==========================================================================
  validates_presence_of :quote, :author, :author_bio
  
  def self.random
    Quote.find_by_id rand(Quote.count) + 1
    #Quote.find(:all)[rand(Quote.count)]
  end
end
