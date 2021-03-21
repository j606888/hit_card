class RichMenu < ApplicationRecord
  def self.get_rich_menus
    resp = $line_client.get_rich_menus
    JSON.parse(resp.body)
  end

  def set_default_rich_menu
    $line_client.set_default_rich_menu(menu_id)
  end

  def upload_image
    object = JSON.parse(File.read("#{Rails.root}/config/settings/rich_menu.json"))[self.name]
    resp = $line_client.create_rich_menu(object)
    self.update(menu_id: JSON.parse(resp.body)['richMenuId'])

    $line_client.create_rich_menu_image(menu_id, File.open(self.file_path))
  end

  def reupload
    $line_client.delete_rich_menu(menu_id)
    self.upload_image
  end

  def link_user_rich_menu(line_user_id)
    $line_client.link_user_rich_menu(line_user_id, menu_id)
  end

end
