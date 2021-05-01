class Category < ApplicationRecord
  has_many :offers
  has_one_attached :category_icon
  validates :name, presence: true
  def to_param
    [id, name.parameterize].join("-")
  end

end
