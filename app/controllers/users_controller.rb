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

  def withdrawal_liqpay_form;  end

  def create_withdrawal_liqpay
    if user_data_correct?
      liqpay = Liqpay.new
      Trial.create(name: 'successfully activate withdrawal_liqpay', test_field1: 'true').save
      liqpay.api('request', {
        action: 'p2pcredit',
        version: '3',
        amount: '1',
        currency: 'UAH',
        description: 'Кешбек з cback.club',
        order_id: "5874#{Time.now.strftime("%I%M%S")}",
        receiver_card: params[:card_num],
        receiver_last_name: params[:last_name],
        receiver_first_name: params[:first_name],
        server_url: 'https://cback.club/withdrawal_get'
      })
      redirect_to action:"show", controller:"users", id: current_user.id, notice: "Очікуйте зарахування на баланс"
    else
      redirect_back fallback_location: :withdrawal_liqpay
    end
  end

  private

  def find_transactions
    @transactions = current_user.transactions
  end

  def user_data_correct?
    (params[:card_num].present? && params[:last_name].present? && params[:first_name].present?) ? true : false
  end

  # def sort_column
  #  Transaction.column_names.include?(params[:sort]) ? params[:sort] : nil
  # end

  # def sort_direction
  #  %w[asc desc].include?(params[:direction]) ? params[:direction] : nil
  # end
end
