class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection 
  has_many :posts, dependent: :destroy
  
  before_save{email.downcase!}
  before_create :create_remember_token

  #attr_accessible :email, :name
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: {with: VALID_EMAIL_REGEX},
  					uniqueness: {case_sensitive: false}
  
  validates :password, presence: true, 
                       length: {minimum: 6}, on: :create
                       #confirmation: true,
                       #:if => :password
                       #:on => [:create, :update]
  validates :password_confirmation, presence: true, 
                                    on: :update, 
                                    :unless =>lambda{|user| user.password.blank?}
                       
  # validates :password_confirmation , presence:true, on: :create
  # validates :password, :presence => {:if => :password_required?}, :confirmation=>true
  has_secure_password

  has_attached_file :avarta, :styles => {:small => "100x100>"},
                                :default_url => "images/default_avarta.jpg",
  #:url => "/system/:attachment/:id/:style/:basename.:extension",
  #:path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
  :url => "/assets/users/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"
  #validates_attachment :avarta, :content_type => ["image/jpg","image/png","image/jpeg"], :not => "image/gif"
  validates_attachment_presence :avarta
  validates_attachment_size :avarta, :less_than =>5.megabytes
validates_attachment_content_type :photo, :content_type =>["image/jpg","image/png","image/jpeg","image/gif"]


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
