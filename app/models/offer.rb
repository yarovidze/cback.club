class Offer < ApplicationRecord
  has_many :transactions
  has_many :favorites, dependent: :destroy
  belongs_to :category
  has_one_attached :image
  validates :name, presence: true
  validates :name, length: { in: 2..50 }  
  validates :alt_name, presence: true
  validates :alt_name, length: { in: 2..50 }  
  validates_numericality_of :cashback_percent, greater_than_or_equal_to: 0
  validates_numericality_of :confirmation, greater_than_or_equal_to: 0
  

  extend FriendlyId
  friendly_id :name, use: :slugged


  def link_to_offer(link, user_id)
    "#{link + user_id.to_s}"
  end
end
  