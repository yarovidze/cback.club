# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transactions, only: %i[show filter_status]

  def show;  end

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
