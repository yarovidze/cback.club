class ContactsController < ApplicationController

  def new 
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
  redirect_to root_path, notice: 'Лист надіслано успішно'
    else
      flash.now[:alert] = 'Невірний E-mail або відсутнє повідомлення'
      render :new
    end
  end
end


