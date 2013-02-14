class Incident < ActiveRecord::Base
  attr_accessible :info, :score, :incident_type , :tag_ids , :creator_id , :assigned_to_id
  has_and_belongs_to_many :tags

  #creator user and assigned_to user relations
  belongs_to :creator , :class_name=>'User'
  belongs_to :assigned_to, :class_name=>'User' 
  
  accepts_nested_attributes_for :tags 

  #for mapping 0,1 saved in DB to meaningful strings
  TYPE_NAME = {-1 => "negative" , 1 => "positive"}

  def type 
  	return TYPE_NAME[self.incident_type]
  end

end
