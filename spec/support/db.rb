ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

class CreateAllTables < ActiveRecord::Migration[5.2]
  def self.up
    create_table(:users) do |t|
      t.string  :name
      t.integer :role
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
