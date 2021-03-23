class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :offer

  scope :on_balance, -> { where('status = 0') }
  scope :in_process, -> { where('status = 1') }
  scope :confirmed, -> { where('status = 2') }
  scope :canceled, -> { where('status = 4') }
end
