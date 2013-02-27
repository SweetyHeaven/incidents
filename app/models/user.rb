require 'set'
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

  #check if user has manager privilage
  def isManager?
    if self.role == "Manager"
      return true
    else
      return false
    end
  end

  #calculate score given to user from incidents
  #in a given time interval
  #if default value is used for interval score field is returned
  def incidents_score(time_interval = "")
    if time_interval == ""
      return score
    end 
    calculated_score = 0
    self.score = 0
    self.assigned_incidents.where("created_at" => time_interval).each do |incident|
      calculated_score += incident.score
      self.score += incident.score
    end
    puts "#{self.id}  #{calculated_score}"
    return calculated_score
  end

  #returns a set of the tags that have been
  #given to that user through incidents
  def related_tags
    tag_names = Set.new #using set to ensure no duplicates
    Incident.includes(:tags) #optimize DB queries
    self.assigned_incidents.each do |incident|
      incident.tags.each do |tag|
        tag_names.add(tag)
      end
    end
    return tag_names
  end
  
end
