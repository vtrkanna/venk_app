class User < ActiveRecord::Base
  validates :name, :presence => true, :length => {:minimum => 5}
  validates :password, :presence => true, :length => {:minimum => 6} #, :format => //
  validates :email, :presence => true, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  has_many :contacts
  byebug
  def self.genereate_token(e)
      Digest::MD5.hexdigest(e)
  end
  def self.authenticate(email, password)
    @user = User.find_by_email_and_password(email, password)
    if @user
      @user
    else
      nil
    end
 end
end
