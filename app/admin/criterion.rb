ActiveAdmin.register Criterion do
  permit_params :tite, :description, :type, :max_score, :min_score

  index do
    selectable_column
    id_column
    column :title
    column :type
    column :max_score
    column :min_score
    actions
  end

  filter :title
  filter :type, as: :select, collection: ['rank', 'text', 'file', 'Rating', 'Checkbox', 'TextualFeadback', 'Header', 'Dropdown']
  filter :max_score
  filter :min_score

  form do |f|
    f.inputs "Criterion Details" do
      f.input :title
      f.input :description
      f.input :type
      f.input :max_score, as: :number
      f.input :min_score, as: :number
    end
    f.actions
  end

end
