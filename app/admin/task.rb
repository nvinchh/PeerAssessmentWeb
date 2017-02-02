ActiveAdmin.register Task do

  permit_params :app_name, :assignment_title, :course_title, :organization_title, :owner_name, :task_description, :task_type

  index do
    selectable_column
    id_column
    column :app_name
    column :assignment_title
    column :course_title
    column :organization_title
    column :owner_name
    column :task_description
    column :task_type
    actions
  end

  filter :assignment_title
  filter :course_title
  filter :organization_title
  filter :owner_name
  filter :task_type, as: :select, collection: ['review', 'submission']
  filter :starts_at
  filter :ends_at

  form do |f|
    f.inputs "Task Details" do
      f.input :app_name
      f.input :assignment_title
      f.input :course_title
      f.input :organization_title
      f.input :owner_name
      f.input :task_description
      f.input :task_type
    end
    f.actions
  end


end
