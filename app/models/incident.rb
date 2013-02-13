class Incident < ActiveRecord::Base
  attr_accessible :info, :score, :incident_type
  has_and_belongs_to_many :tags
  
  #for mapping 0,1 saved in DB to meaningful strings
  TYPE_NAME = {-1 => "negative" , 1 => "positive"}

  def type 
  	return TYPE_NAME[self.incident_type]
  end

end
