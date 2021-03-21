class CreateRichMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :rich_menus do |t|
      t.string :name
      t.string :menu_id
      t.string :file_path

      t.timestamps
    end
  end
end
