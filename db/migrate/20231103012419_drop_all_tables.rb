class DropAllTables < ActiveRecord::Migration[6.0]
  def up
    # Fetch all table names from the database
    table_names = ActiveRecord::Base.connection.tables

    # Exclude system tables if necessary
    table_names -= ['schema_migrations', 'ar_internal_metadata']

    # Drop each table
    table_names.each do |table_name|
      drop_table table_name, if_exists: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
