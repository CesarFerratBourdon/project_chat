class Client < ActiveRecord::Base
  belongs_to :user
  has_many :items
  validates_formatting_of :zip_code, using: :us_zip
  validates_formatting_of :phone_number, using: :us_phone
  validates_formatting_of :email, using: :email
end
