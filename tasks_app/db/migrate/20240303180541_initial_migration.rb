class InitialMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :role, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true

    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
