class Category < ApplicationRecord
  validates :name, presence: true
  def to_param
    [id, name.parameterize].join("-")
  end

end
