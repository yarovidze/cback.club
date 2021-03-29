class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  enum status: { pending: 0, approved: 1, declined: 2, approved_but_stalled: 3, paid: 4 }
  validates_numericality_of :status, greater_than_or_equal_to: 0 
  validates_numericality_of :total, greater_than_or_equal_to: 0
end
