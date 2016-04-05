class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :category
      t.string :type
      t.string :color
      t.string :season
      t.string :size
      t.string :status
      t.text :description
      t.float :price
      t.references :client, index: true
      t.references :outfit, index: true

      t.timestamps
    end
  end
end
