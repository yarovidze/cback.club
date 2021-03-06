ActiveAdmin.register Transaction do

  permit_params :status, :total, :offer_id, :user_id, :action_id, :cashback_sum, :action_date
  filter :user_id, as: :select, collection: User.all.ids


  form do |f|
    f.inputs do
      f.input :user_id, as: :select, collection: User.all.ids.sort()
      f.input :offer
      f.input :status
      f.input :total
      f.input :cashback_sum
      f.input :action_id
      f.input :action_date
    end
    f.actions
  end
  
end
