ActiveAdmin.register Transaction do

  permit_params :status, :total, :offer_id, :user_id
  filter :user_id, as: :select, collection: User.all.ids


  form do |f|
    f.inputs do
      f.input :user_id, as: :select, collection: User.all.ids
      f.input :offer
      f.input :status
      f.input :total
      f.input :cashback_sum
      f.input :action_id
    end
    f.actions
  end
  
end
