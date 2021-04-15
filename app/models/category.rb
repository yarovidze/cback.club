class Category < ApplicationRecord
  has_many :offers
  validates :name, presence: true
  def to_param
    [id, name.parameterize].join("-")
  end

end
