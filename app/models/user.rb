class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection 
  
  before_save{email.downcase!}
  before_create :create_remember_token

  #attr_accessible :email, :name
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: {with: VALID_EMAIL_REGEX},
  					uniqueness: {case_sensitive: false}
  
  validates :password,presence: true, length: {minimum:6}, :on => :create
  validates :password_confirmation , presence:true, on: :create
  #validates :password, :presence => {:if => :password_required?}, :confirmation=>true
  has_secure_password


  #CREATE REMEMBER TOKEN FOR AUTHENTICATE SESSION
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  #Method tao 1 authenticate_token
  def generate_auth_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64         
    end while User.exists?(column =>self[column])
  end

  def send_password_reset
    generate_auth_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

end
