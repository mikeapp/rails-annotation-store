class CreateAnnotations < ActiveRecord::Migration[5.0]
  def change
    create_table :annotations do |t|
      t.text :data
      t.text :search_text
      t.string :motivation
      t.string :resource_id
      t.boolean :active

      t.timestamps
    end

    create_table :targets do |t|
      t.string :manifest
      t.string :canvas
      t.text :selector
      t.string :bbox
      t.belongs_to :annotation, index: true

      t.timestamps
    end
  end
end
