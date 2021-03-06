class AddStatusAndPasswordToContests < ActiveRecord::Migration[5.1]
  def up
    add_column :contests, :password, :string
    add_column :contests, :status, :integer

    Contest.update_all("status=#{Contest.statuses['outside']}, password=''")

    change_column :contests, :password, :string, null: false, default: ''
    change_column :contests, :status, :integer, null: false, default: Contest.statuses['outside']
  end

  def down
    remove_column :contests, :password
    remove_column :contests, :status
  end
end
