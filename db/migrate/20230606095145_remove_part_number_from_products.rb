class RemovePartNumberFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :score, :string
  end
end
