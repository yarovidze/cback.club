class Offer < ApplicationRecord
  has_many :transactions
  has_many :favorites
  belongs_to :category
  has_one_attached :image

  extend FriendlyId
  friendly_id :name, use: :slugged
end
