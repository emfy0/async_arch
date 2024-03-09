class InitialMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest
      t.string :role, null: false
      t.uuid :public_id, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true

    create_table :sessions do |t|
      t.uuid :token, null: false
      t.references :user, null: false, foreign_key: true

      t.datetime :valid_until, null: false

      t.timestamps
    end

    add_index :sessions, :token, unique: true
  end
end
