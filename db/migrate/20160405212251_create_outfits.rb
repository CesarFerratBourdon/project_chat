class CreateOutfits < ActiveRecord::Migration
  def change
    create_table :outfits do |t|
      t.string :name
      t.text :description
      t.string :category
      t.references :client, index: true

      t.timestamps
    end
  end
end
