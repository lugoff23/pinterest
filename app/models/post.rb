class Post < ActiveRecord::Base
  belongs_to :user
  
  acts_as_booky
  
  attr_accessible :body, :image, :title, :is_published, :user
  
  has_attached_file :image, styles: {
    tiny: '48x48#',
    small: '100x100#',
    medium: '240x',
    large: '480x360>'
  }

  acts_as_likeable  
  
  def inheritance_column
    'post_type'
  end
  
  # before_save :fetch_link
  # 
  # def fetch_link
  #   Booky::Leecher.get_link(original_link)
  # end
end
