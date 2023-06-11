class AddCaregoryToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :category, :string
  end
end
