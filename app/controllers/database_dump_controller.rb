class DatabaseDumpController < ApplicationController
    def index
    end
    def import_database_form
    end
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
            dump_command = "sqlite3 #{db_path} .dump | grep '^INSERT INTO' | grep -v '^INSERT INTO schema_migrations' | grep -v '^INSERT INTO ar_internal_metadata' > #{Rails.root}/db/db_dump.sql"
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

    def import_database     
        db_config = Rails.application.config.database_configuration[Rails.env]
        db_adapter = db_config['adapter']

        puts params

        if params[:dump_file].present? # If a file is uploaded
            file = params[:dump_file]
            uploaded_file_path = Rails.root.join('uploads', file.original_filename)
    
            File.open(uploaded_file_path, 'wb') do |f|
              f.write(file.read)
            end
    
            dump_file_path = uploaded_file_path
        else
            flash[:error] = "Please upload a file"
            redirect_to import_database_path and return
        end
    
        case db_adapter
        when /postgresql/
            import_command = "pg_restore --clean --dbname=#{db_config['database']} #{dump_file_path}"
        when /mysql/
            import_command = "mysql -u#{db_config['username']} -p#{db_config['password']} #{db_config['database']} < #{dump_file_path}"
        when /sqlite/
            puts "before deletion"
            # Clear the tables before importing
            ActiveRecord::Base.connection.tables.each do |table|
                ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
            end
            puts "after deletion"
            db_path = db_config['database']
            import_command = "sqlite3 #{db_path} < #{dump_file_path}"
        else
            flash[:error] = "Database adapter not supported."
            redirect_to adminlanding_path and return
        end
    
        success = system(import_command)
    
        if success
            flash[:success] = "Database imported successfully"
        else
            flash[:error] = "Failed to import the database"
        end
    
        redirect_to adminlanding_path
    end
end
