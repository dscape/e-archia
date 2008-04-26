# ============================================================================
# e-archia: user model
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
require 'digest/sha2'

class User < ActiveRecord::Base
  # ==========================================================================
  # database relationships
  # ==========================================================================
  has_and_belongs_to_many :roles
  has_many :stories
  has_many :projects

  # ==========================================================================
  # attributes
  # ==========================================================================
  # should be accessor lamer coder
  attr_protected :password_hash, :password_salt
  attr_accessor :password

  # ==========================================================================
  # data validation
  # ==========================================================================
  validates_presence_of :username, 
                        :name, 
                        :password, 
                        :email, 
                        :enabled
                        
  validates_uniqueness_of :username, 
                          :case_sensitive => false
  validates_uniqueness_of :email,
                          :case_sensitive => false

  validates_confirmation_of :password
  
  validates_format_of :email, 
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :homepage,
                      :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  validates_length_of :username,
                      :within     => 3..64,
                      :too_long   => "deve ter menos que %d caracteres",
                      :too_short  => "deve ter mais que %d caracteres"
  validates_length_of :password,
                      :within => 6..20,
                      :too_long   => "deve ter menos que %d caracteres",
                      :too_short  => "deve ter mais que %d caracteres"
  validates_length_of :first_name,
                      :maximum => 64,
                      :message => "deve ter menos que %d caracteres"
  validates_length_of :last_name,
                      :maximum => 64,
                      :message => "deve ter menos que %d caracteres"
  validates_length_of :email,
                      :maximum => 128,
                      :message => "deve ter menos que %d caracteres"
  validates_length_of :profile,
                      :maximum => 2048,
                      :message => "deve ter menos que %d caracteres"
  validates_length_of :homepage,
                      :maximum => 128,
                      :message => "deve ter menos que %d caracteres"
  # validates_length_of :openid,     :maximum => 128

 # ==========================================================================
 # before_save filter
 # ==========================================================================
 #skip_before_save :only => { :edit }
 #skip_validation_password => edit
  def before_save
    unless password.blank?
      salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp 
      self.password_salt, self.password_hash = 
      salt, Digest::SHA256.hexdigest(password + salt)
    end
  end

  # ==========================================================================
  # attributes - lame style
  # ==========================================================================
  def name
    [first_name, last_name].join(' ')
  end

  def name=(name)
    split = name.split(' ')
    unless split.size < 2
      self.first_name = split.first
      self.last_name = split.last
    else
      self.first_name = name
      self.last_name  = ""
    end
  end

  # ==========================================================================
  # class methods
  # ==========================================================================
  def self.authenticate(username, password) 
    user = User.find(:first, :conditions => ['username = ?', username]) 
    if user.blank?
      raise "O utilizador não existe" 
    elsif !user.enabled
      raise "O administrador optou por congelar o teu perfil"
    elsif Digest::SHA256.hexdigest(password + user.password_salt) != user.password_hash 
      raise "A autenticação falhou"
    else
      user.update_attribute(:last_login_at, Time.now)
    end 
    user 
  end
  
  def avatar_atribute=(avatar_atribute)
    avatar.build(avatar_atribute)
  end

end

