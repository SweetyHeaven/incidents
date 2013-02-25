class Incident < ActiveRecord::Base
  attr_accessible :info, :score, :incident_type , :tag_ids , :creator_id , :assigned_to_id
  has_and_belongs_to_many :tags

  #creator user and assigned_to user relations
  belongs_to :creator , :class_name=>'User'
  belongs_to :assigned_to, :class_name=>'User' 
  
  accepts_nested_attributes_for :tags 

  before_save :set_score
  after_save :increase_score
  before_destroy :decrease_score

  #for mapping 0,1 saved in DB to meaningful strings
  TYPE_NAME = {-1 => "negative" , 1 => "positive"}

  def type 
  	return TYPE_NAME[self.incident_type]
  end

  def set_score()
    if self.incident_type != 1 && self.incident_type != -1
      self.incident_type = 1 #default is positive
    end
    self.score = self.incident_type * 5;
  end

  def increase_score()
    #add incident's score to assigned user's score
    @assigned_user = self.assigned_to
    @assigned_user.score += self.score
    @assigned_user.save  

    self.send_notifications()
  end

  def decrease_score()
    #remove incident's score from assigned user's score
    @assigned_user = self.assigned_to
    @assigned_user.score -= self.score
    @assigned_user.save
  end

  #notify users about new created incident
  def send_notifications()
    #send a notification mail to assigned user incase of +ve incidents
    if self.incident_type == 1 #positive incident
      UserMailer.delay.incident_notification(self) 
      
      #send broadcast message for all users
      UserMailer.delay.incident_broadcast(self)

    else #negative incident
      UserMailer.delay.negative_incident_notification(self)
    end 
  end

end
