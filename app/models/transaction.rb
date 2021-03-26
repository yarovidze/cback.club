class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  validates_numericality_of :status, greater_than_or_equal_to: 0 
  validates_numericality_of :total, greater_than_or_equal_to: 0
  
  

end
