class InitialMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :role, null: false

      t.decimal :balance, null: false, default: 0

      t.uuid :public_id, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :public_id, unique: true

    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.uuid :public_id, null: false

      t.decimal :reward, null: false
      t.decimal :penalty, null: false

      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :tasks, :public_id, unique: true

    create_table :billing_cycles do |t|
      t.datetime :start_date
      t.datetime :end_date

      t.boolean :active, null: false, default: false

      t.timestamps
    end

    add_index :billing_cycles, :active, where: 'active'

    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, foreign_key: true
      t.references :billing_cycle, null: false, foreign_key: true

      t.string :kind, null: false

      t.decimal :debit, null: false, default: 0
      t.decimal :credit, null: false, default: 0

      t.timestamps
    end

    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :transaction, null: false, foreign_key: true
      t.references :billing_cycle, null: false, foreign_key: true

      t.decimal :amount, null: false, default: 0

      t.timestamps
    end
  end
end
