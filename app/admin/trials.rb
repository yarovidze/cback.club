ActiveAdmin.register Trial do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  show do
    attributes_table do
      row :name
      row :test_field1
      row :test_field2
      row :test_field3
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :test_field1
      f.input :test_field2
      f.input :test_field3
    end
    f.actions
  end
end
