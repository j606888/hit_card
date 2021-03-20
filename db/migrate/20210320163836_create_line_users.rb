class CreateLineUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :line_users do |t|
      t.string :line_id
      t.string :name
      t.string :account
      t.string :password
      t.integer :plan, default: 0
      t.integer :mode, default: 0
      t.string :cookie

      t.timestamps
    end
  end
end
