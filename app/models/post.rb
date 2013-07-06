class Post < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :body, :image, :title, :is_published, :user
  
  has_attached_file :image, styles: {
    tiny: '48x48#',
    small: '100x100#',
    medium: '240x',
    large: '480x360>'
  }
  
end
