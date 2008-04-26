# ============================================================================
# e-archia: right model
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class Right < ActiveRecord::Base
  # ==========================================================================
  # database relationships
  # ==========================================================================
  has_and_belongs_to_many :roles
  
  # ==========================================================================
  # data validation
  # ==========================================================================
  validates_presence_of :name, :controller, :action

  # ==========================================================================
  # attributes - lame style
  # ==========================================================================
  def set_name=(name)
    self.name = name.downcase
  end
  
  def set_controller=(controller)
    self.controller = controller.downcase
  end
  
  def set_action=(action)
    self.action = action.downcase
  end
  
end