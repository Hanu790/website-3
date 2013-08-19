class User < ActiveRecord::Base
  #include ActiveModel::ForbiddenAttributesProtection 
  before_save{email.downcase!}

  attr_accessible :email, :name
  validates :name, presence: true, length: {maximum: 50}
  # validate :password,presence: true, length: {maximum:6}
  # validate :password_confirmation , presence:true
  # has_secure_password
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: {with: VALID_EMAIL_REGEX},
  					uniqueness: {case_sensitive: false}

  
end
