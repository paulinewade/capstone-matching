class DatabaseDumpController < ApplicationController
    def dump_database
        if Rails.env.production?
           db_adapter = ActiveRecord::Base.connection_db_config.configuration_hash[:adapter]
        else
            db_adapter = current_db_adapter
        end

        begin
            case db_adapter
            when /postgresql/
                dump_content = generate_postgresql_dump
            when /mysql/
                dump_content = generate_mysql_dump
            when /sqlite/
                dump_content = generate_sqlite_dump
            else
                flash[:error] = "Exporting database is not supported for this database type"
                redirect_to adminlanding_path and return
            end

            send_database_dump(dump_content)
        rescue StandardError => e
            flash[:error] = "Error exporting database: #{e.message}"
        end
        
        redirect_to adminlanding_path unless performed?
    end

    private

    def current_db_adapter
        Rails.application.config.database_configuration[Rails.env]['adapter']
    end

    def generate_sqlite_dump
        `sqlite3 #{Rails.application.config.database_configuration[Rails.env]['database']} .dump`
    end

    def generate_mysql_dump
        db_config = Rails.application.config.database_configuration[Rails.env]
        username = db_config['username']
        password = db_config['password']
        database = db_config['database']
        `mysqldump -u #{username} -p#{password} #{database}`
    end
    
    def generate_postgresql_dump
        dump_filename = "database_dump_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.sql"
        system("heroku run 'pg_dump $DATABASE_URL' > #{dump_filename}")
        File.read(dump_filename)
    ensure
        File.delete(dump_filename) if File.exist?(dump_filename)
    end
    
    def send_database_dump(content)
        send_data content,
                  filename: "database_dump_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.sql",
                  type: "application/sql"
    end
end