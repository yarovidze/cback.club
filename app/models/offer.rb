class Offer < ApplicationRecord
  has_many :transactions
  has_many :favorites
  belongs_to :category
end
