class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :Semester
      t.string :Name
      t.string :Sponsor
      t.text :Description
      t.string :Link

      t.timestamps
    end
  end
end
