# ============================================================================
# e-archia: story model
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class Story < ActiveRecord::Base
  # ==========================================================================
  # database relationships
  # ==========================================================================
  belongs_to :user
  
  # ==========================================================================
  # data validation
  # ==========================================================================
  validates_presence_of :title, :contents
  
  validates_length_of :title, 
                      :within     => 3..256,
                      :too_long   => "deve ter menos que %d caracteres",
                      :too_short  => "deve ter mais que %d caracteres"
  validates_length_of :contents, 
                      :maximum => 2048,
                      :message => "deve ter menos que %d caracteres"
  
  # ==========================================================================
  # before_create filter
  # ==========================================================================
  def before_create
    @attributes['permalink'] = 
      title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end

  def to_param
    "#{id}-#{permalink}"
  end
  
end