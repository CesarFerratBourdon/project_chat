class Client < ActiveRecord::Base
  validates_formatting_of :zip_code, using: :us_zip
  validates_formatting_of :phone_number, using: :us_phone
  validates_formatting_of :email, using: :email
  #vneed to validate the presence of other fields when a new client register

  belongs_to :user
  has_many :items

  has_attached_file :avatar, styles: { full: '500x500#', medium: '300x300#', thumb: '100x100#' }, default_url: '/images/:style/missing.png'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :avatar, less_than: 15.megabytes

end
