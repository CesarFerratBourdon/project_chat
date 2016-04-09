class Item < ActiveRecord::Base
  belongs_to :client
  belongs_to :outfit

  has_attached_file :picture, styles: { full: '1200x1200>', medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :picture, less_than: 15.megabytes

end
