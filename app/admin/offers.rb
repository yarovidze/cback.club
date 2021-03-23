ActiveAdmin.register Offer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :name, :image, :link, :category_id, :description, :cashback, :confirmation, :slug, :alt_name, :cashback_percent
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :image, :link, :category_id, :description, :cashback, :confirmation, :slug, :alt_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :cashback
    column :category
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :cashback
      row :category
      row :confirmation
    end
  end

  form do |f|
    f.inputs do
      f.input :category
      f.input :name
      f.input :description, as: :quill_editor
      f.input :image, as: :file
      f.input :link
      f.input :cashback
      f.input :confirmation
      f.input :alt_name
      f.input :cashback_percent
    end
    f.actions
  end
end

