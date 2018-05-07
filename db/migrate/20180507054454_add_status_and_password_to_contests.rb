class AddStatusAndPasswordToContests < ActiveRecord::Migration[5.1]
  def change
    add_column :contests, :password, :string
    add_column :contests, :status, :integer
  end
end
