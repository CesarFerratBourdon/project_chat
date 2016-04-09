class RemoveUserRefFromClient < ActiveRecord::Migration
  def change
    remove_reference :clients, :user, index: true
  end
end
