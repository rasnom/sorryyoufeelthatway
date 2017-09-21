class CardTemplate < ApplicationRecord
  validates :greeting, presence: true
end
