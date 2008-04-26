# ============================================================================
# e-archia: create_quotes migration                                        009
# author: nunojobpinto[at]gmail[dot]com                                      
# ============================================================================
class CreateQuotes < ActiveRecord::Migration
  # ==========================================================================
  # version UP
  # ==========================================================================
  def self.up
    # ========================================================================
    # create tables
    # ========================================================================
    create_table :quotes do |t|
      t.string :quote,   :limit => 2048, :null => false
      t.string :author, :limit => 64,  :null => false
      t.string :author_bio, :limit => 512,  :null => false
      t.timestamps
    end

    # ========================================================================
    # create some data
    # ========================================================================
    Quote.create(:quote => 'Keep away from people who try to belittle your ambitions. Small people always do that, but the really great make you feel that you, too, can become great.',
    :author => 'Mark Twain',
    :author_bio => 'Escritor')
  
    Quote.create(:quote => 'The question of whether computers can think is like the question of whether submarines can swim.',
    :author => 'Edsger Dijkstra',
    :author_bio => 'Cientista')
    
    Quote.create(:quote => 'Computers are useless. They can only give you answers.',
    :author => 'Picasso',
    :author_bio => 'Pintor')

    Quote.create(:quote => 'The competent programmer is fully aware of the strictly limited size of his own skull; therefore he approaches the programming task in full huminity; and among other things he avoids clever tricks like the plague.',
    :author => 'Edsger Dijkstra',
    :author_bio => 'Cientista')

    Quote.create(:quote => 'A programming language is a tool that has profound influence on our thinking habits.',
    :author => 'Edsger Dijkstra',
    :author_bio => 'Cientista')
    
    Quote.create(:quote => 'Simplicity is prerequisite for reliability.',
    :author => 'Edsger Dijkstra',
    :author_bio => 'Cientista')
    
    Quote.create(:quote => 'It is practically impossible to teach good programming to students that have had a prior exposure to BASIC: as potential programmers they are mentally mutilated beyond hope of regeneration.',
    :author => 'Edsger Dijkstra',
    :author_bio => 'Cientista')

    Quote.create(:quote => 'Anyone who has never made a mistake has never tried anything new.',
    :author => 'Albert Einstein',
    :author_bio => 'Cientista')

    Quote.create(:quote => 'I am always doing that which I can not do, in order I may learn how to do it.',
    :author => 'Picasso',
    :author_bio => 'Pintor')

    Quote.create(:quote => 'Everything should be made as simple as possible, but not simpler.',
    :author => 'Albert Einstein',
    :author_bio => 'Cientista')

    Quote.create(:quote => 'Great spirits have often encountered violent opposition from weak minds.',
    :author => 'Albert Einstein',
    :author_bio => 'Cientista')

    Quote.create(:quote => 'Only two things are infinite, the universe and human stupidity, and I\'m not sure about the former.',
    :author => 'Albert Einstein',
    :author_bio => 'Cientista')
    
    Quote.create(:quote => 'The surest way to corrupt a youth is to instruct him to hold in higher regard those who think alike than those who think differently.',
    :author => 'Friedrich Nietzsche',
    :author_bio => 'Filosofo')

    Quote.create(:quote => 'An eye for an eye makes the whole world blind.',
    :author => 'Mahatma Gandhi',
    :author_bio => 'Pacifista')

    Quote.create(:quote => 'First they ignore you, then they laugh at you, then they fight you, then you win.',
    :author => 'Mahatma Gandhi',
    :author_bio => 'Pacifista')
  end
  
  # ==========================================================================
  # version DOWN
  # ==========================================================================
  def self.down
    # ========================================================================
    # drop tables
    # ========================================================================
    drop_table :quotes
  end
end
