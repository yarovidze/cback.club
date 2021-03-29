class UsersController < ApplicationController
  def show
    @transactions = current_user.transactions
  end
end
