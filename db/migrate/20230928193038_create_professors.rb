class CreateProfessors < ActiveRecord::Migration[7.0]
  def change
    create_table :professors do |t|
      t.string :email
      t.string :semester, array: true, default: '{}'
      t.string :section, array: true, default: '{}'
      t.string :first_name
      t.string :last_name
      t.boolean :admin_approved, default: false
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
