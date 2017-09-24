class CardTemplate < ApplicationRecord
  validates :greeting, presence: true
  validates :image_file, presence: true

  has_many :cards
end

