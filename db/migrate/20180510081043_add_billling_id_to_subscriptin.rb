class AddBilllingIdToSubscriptin < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :billing_id, :integer, null: false
  end
end
