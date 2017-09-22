class Card < ApplicationRecord
  validates :recipient_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  belongs_to :card_template
end
