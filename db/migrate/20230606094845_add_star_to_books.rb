class AddStarToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :score, :string
  end
end
