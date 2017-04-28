class CreateAdminRole < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_roles do |t|
      t.references :user, foreign_key: true, index: { unique: true }, null: false
      t.timestamps null: false
    end
  end
end
