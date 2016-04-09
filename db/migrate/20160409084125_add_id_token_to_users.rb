class AddIdTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :id_token, :string
  end
end
