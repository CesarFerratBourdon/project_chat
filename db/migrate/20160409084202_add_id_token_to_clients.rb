class AddIdTokenToClients < ActiveRecord::Migration
  def change
    add_column :clients, :id_token, :string
  end
end
