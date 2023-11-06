class CreateProfessorPreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :professor_preferences do |t|
      t.references :professor, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
