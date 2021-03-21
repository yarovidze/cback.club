class Offer < ApplicationRecord
  has_many :transactions
  has_many :favorites, dependent: :destroy
  belongs_to :category
  has_one_attached :image

  #extend FriendlyId
  #friendly_id :name, use: :slugged

  def link_to_offer(link, user_id)
    "#{link + user_id.to_s}"
  end
end
