class CreateEditorials < ActiveRecord::Migration[5.0]
  def change
    create_table :editorials do |t|
      t.integer :contest_id
      t.string :content
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
