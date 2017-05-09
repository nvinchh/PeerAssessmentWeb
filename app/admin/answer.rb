ActiveAdmin.register Answer do
  permit_params :comment, :comment2, :criterion_id, :rank, :score

  index do
    selectable_column
    id_column
    column :comment
    column :comment2
    column :criterion_id
    column :rank
    column :score
    actions
  end

  filter :criterion_id
  filter :comment
  filter :rank
  filter :score
  filter :submitted_at

  form do |f|
    f.inputs "Answer Details" do
      f.input :comment
      f.input :comment2
      f.input :criterion_id
      f.input :rank, as: :number
      f.input :score, as: :number
    end
    f.actions
  end



end
