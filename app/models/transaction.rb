class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  enum status: { on_balance: 0, in_process: 1 ,confirmed: 2 ,canceled: 4 }
end
