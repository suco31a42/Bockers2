class AddPartNumberToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :favorites_count, :integer
  end
end
