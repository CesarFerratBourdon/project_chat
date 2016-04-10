class AddCountClientToUsers < ActiveRecord::Migration
  def change
    add_column :users, :count_client, :integer
  end
end
