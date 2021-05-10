# frozen_string_literal: true

require 'liqpay'
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transactions, only: %i[show filter_status]

  def show; end

  def filter_status
    @transactions = @transactions.where(status: params[:status]) if params[:status] != "all"
    render 'transactions/_filter_status'
  end

  def withdrawal_liqpay
    if request.post?
      error_notice = user_data_correct
      if error_notice.any?
        @errors = error_notice
        render 'users/_withdrawal_errors'
      else
        liqpay = Liqpay.new
        withdrawal_id = "1000#{Time.now.strftime('%I%M%S')}".to_i
        amount = current_user.transactions.where(status: 1).sum(:cashback_sum)
        Transaction.create(user_id: current_user.id,
                           action_id: withdrawal_id,
                           cashback_sum: amount,
                           status: 5,
                           offer_id: Offer.first.id).save

        liqpay.api('request', {
                     action: 'p2pcredit',
                     version: '3',
                     amount: amount,
                     currency: 'UAH',
                     description: 'Кешбек з cback.club',
                     order_id: withdrawal_id.to_i,
                     receiver_card: params[:card_num],
                     receiver_last_name: params[:last_name].capitalize,
                     receiver_first_name: params[:first_name].capitalize,
                     server_url: 'https://cback.club/withdrawal_get'
                   })
        flash[:notice] = 'Очікуйте зарахування на баланс'
        redirect_to action: 'show', controller: 'users', id: current_user.id 
      end
    end
  end

  private

  def find_transactions
    @transactions = current_user.transactions
  end

  def user_data_correct
    error_notice = []
    valid_name_regex = /^[a-zA-Zа-яА-Яі]*$/
    error_notice.push('Введіть карту') if params[:card_num].blank?
    error_notice.push('Введіть прізвище') if params[:last_name].blank?
    error_notice.push("Введіть ім\\'я") if params[:first_name].blank?
    unless params[:last_name].match(valid_name_regex)
      error_notice.push('В прізвищі не можуть бути спец символи та цифри')
    end
    error_notice.push('В імені не можуть бути спец символи та цифри') unless params[:first_name].match(valid_name_regex)
    error_notice.push('Неправильний номер картки') unless params[:card_num].to_s.scan(/\D/).empty?
    error_notice.push('Закороткий номер картки') unless params[:card_num].length == 16
    error_notice
  end
end
