class User < ActiveRecord::Base
  has_many :posts
  # Include default devise modules. Others available are:
  # :token_authenticatable, 
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :avatar, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_attached_file :avatar, styles: {
    tiny: '24x24#',
    small: '180x180#',
    medium: '300x200#',
    large: '260x180<'
  }

  acts_as_followable
  acts_as_follower
  acts_as_liker
end
