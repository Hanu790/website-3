class Post < ActiveRecord::Base
	include ActiveModel::ForbiddenAttributesProtection 
	attr_accessible :content, :title, :user_id
  	belongs_to :user
  	
  	default_scope -> {order('created_at DESC')}
  	validates :user_id, presence: true
  	validates :content, presence: true
end
