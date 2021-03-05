ActiveAdmin.register Transaction do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :status, :total, :offer_id, :user_id
  filter :user_id, as: :select, collection: User.all.ids
  # permit_params do
  #   permitted = [:status, :total, :user_id, :offer_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.inputs do
      f.input :user_id, as: :select, collection: User.all.ids
      f.input :offer_id, as: :select, collection: Offer.name
      f.input :status
      f.input :total
    end
    f.actions
  end
end
