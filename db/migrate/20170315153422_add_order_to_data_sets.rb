class AddOrderToDataSets < ActiveRecord::Migration[5.0]
  def up
    add_column :data_sets, :order, :integer
    ::DataSet.all.map do |data_set|
      data_set.update(order: data_set.id)
    end
    change_column :data_sets, :order, :integer, null: false
  end

  def down
    remove_column :data_sets, :order
  end
end
