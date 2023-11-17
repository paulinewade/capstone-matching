class DatabaseDumpController < ApplicationController
    def dump_database
        db_config = Rails.application.config.database_configuration[Rails.env]
        db_adapter = db_config['adapter']

        case db_adapter
        when /postgresql/
            dump_command = "pg_dump #{db_config['database']} > #{Rails.root}/db/db_dump.sql"
        when /mysql/
            dump_command = "mysqldump -u#{db_config['username']} -p#{db_config['password']} #{db_config['database']} > #{Rails.root}/db/db_dump.sql"
        when /sqlite/
            db_path = db_config['database']
            dump_command = "sqlite3 #{db_path} .dump > #{Rails.root}/db/db_dump.sql"
        else
            flash[:error] = "Database adapter not supported"
            redirect_to adminlanding_path and return
        end

        success = system(dump_command)
        # puts success

        if success
            flash[:success] = "Database exported successfully to the db folder with name db_dump.sql"
        else
            flash[:error] = "Failed to export the database"
        end
        
        redirect_to adminlanding_path 
    end
end
