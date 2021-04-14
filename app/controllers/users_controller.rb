# frozen_string_literal: true
require 'liqpay'
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transactions, only: %i[show filter_status]

  def show; end

  def create_withdrawal_request
    Transaction.where(user_id: current_user.id, status: 0).each do |transaction|
      puts transaction.id
      transaction.status = 1
      transaction.save
    end
  end

  def filter_status
    @transactions = @transactions.where(status: params[:status])
    render 'transactions/_filter_status'
  end

  def withdrawal_liqpay

    liqpay = Liqpay.new
    @a = Transaction.create(user_id: current_user.id, action_id: "111111".to_i, offer_id: 1, status: 3,  cashback_percent: 2).save
    liqpay.api('request', {
      action: 'p2pcredit',
      version: '3',
      amount: '1',
      currency: 'UAH',
      description: 'Кешбек з cback.clib',
      order_id: '111',
      receiver_card: '4731195301524633',
      receiver_last_name: 'LastName',
      receiver_first_name: 'FirstName',
      server_url: 'https://cback.club/withdrawal_get'
    })
  end

  private

  def find_transactions
    @transactions = current_user.transactions
  end



  # def sort_column
  #  Transaction.column_names.include?(params[:sort]) ? params[:sort] : nil
  # end

  # def sort_direction
  #  %w[asc desc].include?(params[:direction]) ? params[:direction] : nil
  # end
end
