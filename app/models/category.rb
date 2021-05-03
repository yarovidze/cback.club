class Category < ApplicationRecord
  has_many :offers
  has_one_attached :category_icon
  validates :name, presence: true
  validates :name, length: { in: 5..50 }  
  def to_param
    [id, name.parameterize].join("-")
  end

end
