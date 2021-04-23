# frozen_string_literal: true

require 'liqpay'
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transactions, only: %i[show filter_status]

  def show;  end

  def create_withdrawal_request
    Transaction.where(user_id: current_user.id, status: 0).each do |transaction|
      puts transaction.id
      transaction.first.status = 1
      transaction.save
    end
  end

  def filter_status
    @transactions = @transactions.where(status: params[:status])
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
        redirect_to action: 'show', controller: 'users', id: current_user.id, notice: 'Очікуйте зарахування на баланс'
      end
    end
  end

  private

  def find_transactions
    @transactions = current_user.transactions
  end

  def user_data_correct
    error_notice = []
    valid_name_regex = /^[a-zA-Zа-яА-Я]*$/
    error_notice.push('Введіть карту') if params[:card_num].blank?
    error_notice.push('Введіть Прізвище') if params[:last_name].blank?
    error_notice.push("Введіть Ім'я") if params[:first_name].blank?
    unless params[:last_name].match(valid_name_regex)
      error_notice.push('В Прізвещі не можуть бути спец символи та цифри')
    end
    error_notice.push('В Імені не можуть бути спец символи та цифри') unless params[:first_name].match(valid_name_regex)
    error_notice.push('Закороткий номер картки') unless params[:card_num].match(/^[1-9]*$/)
    error_notice.push('Неправильний номер картки') unless params[:card_num].length <= 16
    error_notice
  end

  # def sort_column
  #  Transaction.column_names.include?(params[:sort]) ? params[:sort] : nil
  # end

  # def sort_direction
  #  %w[asc desc].include?(params[:direction]) ? params[:direction] : nil
  # end
end
