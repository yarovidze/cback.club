class ContactsController < ApplicationController

  def new 
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
  redirect_to root_path, notice: 'Message sent successfully'
    else
      flash.now[:alert] = 'Invalid e-mail or message'
      render :new
    end
  end
end


