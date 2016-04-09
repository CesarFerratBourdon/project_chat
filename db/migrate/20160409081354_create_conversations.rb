class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :client, index: true
      t.string :conversation_id

      t.timestamps
    end
  end
end
