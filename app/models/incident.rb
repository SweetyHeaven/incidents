class Incident < ActiveRecord::Base
  attr_accessible :info, :score, :type
  has_and_belongs_to_many :tags
end
