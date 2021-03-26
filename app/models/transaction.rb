class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  enum status: { on_balance: 0, in_process: 1 ,confirmed: 2 ,canceled: 4 }
  validates_numericality_of :status, greater_than_or_equal_to: 0 
  validates_numericality_of :total, greater_than_or_equal_to: 0
end
