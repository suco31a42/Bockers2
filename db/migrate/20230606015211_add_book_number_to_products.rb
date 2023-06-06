class AddBookNumberToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :score, :float
  end
end
