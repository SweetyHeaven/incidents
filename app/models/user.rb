class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  				  :first_name, :last_name, :score , :role

  #validation				  
  validates :first_name,  :presence => true
  validates :last_name,  :presence => true
  
  #role describes the privilage assosiated with each user
  validates :role ,:inclusion => { :in => %w(Employee Manager), 
  								   :message => "%{value} is not a valid role" }

  #user profile image
  attr_accessible :avatar								   
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "30x30>" }

  #user incidents
  has_many :created_incidents, :foreign_key => 'creator_id', :class_name => 'Incident'
  has_many :assigned_incidents , :foreign_key => 'assigned_to_id', :class_name => 'Incident'
 
def name
  "#{self.first_name} #{self.last_name}"
end

end
