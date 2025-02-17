class AddForeignKeyToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :cart_items, :products
  end
end
