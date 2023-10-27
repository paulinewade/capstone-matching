class RemoveProfessorIdFromProfessors < ActiveRecord::Migration[7.0]
  def up
    remove_column :professors, :professor_id
  end
end
