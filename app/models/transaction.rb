# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  #approved_but_stalled ==  pending !!!!!
  enum status: { pending: 0, approved: 1, declined: 2, approved_but_stalled: 3, paid: 4, interim_proces: 5 }

  def user_cashback
    cashback_sum * offer.cashback_percent
  end
end
