require 'sqlite3'
require 'yaml'

class DBConnection
  ROOT_FOLDER = File.join(File.dirname(__FILE__), '..', '..')

  CONFIG = YAML.load_file(File.join(ROOT_FOLDER, 'config', 'database.yml'))

  PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
  # https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
  APP_SQL_FILE = File.join(ROOT_FOLDER, 'db', 'seed.sql')
  APP_DB_FILE = File.join(ROOT_FOLDER, CONFIG['development']['database'])

  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{APP_DB_FILE}'",
      "cat '#{APP_SQL_FILE}' | sqlite3 '#{APP_DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(APP_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
