ActiveAdmin.register Offer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :image, :link, :category_id, :description, :cashback
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :image, :link, :category_id, :description, :cashback]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  show do
    attributes_table do
      row :name
      row :cashback
      row :category
    end
  end

  form do |f|
    f.inputs do
      f.input :category
      f.input :name
      f.input :description
      f.input :image, as: :file
      f.input :link
      f.input :cashback
    end
    f.actions
  end
end
