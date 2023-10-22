class ChangeFormLockedDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :students_new, :form_locked, false
  end
end
