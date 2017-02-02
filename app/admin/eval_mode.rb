ActiveAdmin.register EvalMode do

  permit_params :description

  index do
    selectable_column
    id_column
    column :description
    actions
  end

  filter :id
  filter :description

  form do |f|
    f.inputs "Evaluation Mode Details" do
      f.input :description
    end
    f.actions
  end
end
