ActiveAdmin.register Actor do

  permit_params :role

  index do
    selectable_column
    id_column
    column :role
    actions
  end

  filter :id
  filter :role, as: :select, collection: ['instructor', 'student', 'ta', 'admin']

  form do |f|
    f.inputs "Actor Details" do
      f.input :role, as: :select, collection: ['instructor', 'student', 'ta', 'admin']
    end
    f.actions
  end

end
