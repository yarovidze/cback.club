ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation,:admin

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :provider
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :provider
      row :created_at
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
    end
    f.actions
  end

end
