class Client < ActiveRecord::Base
  belongs_to :user
  has_many :items
  validates_formatting_of :zip_code, using: :us_zip
end
