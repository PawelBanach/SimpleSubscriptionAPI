class AddColumnsToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :name, :string, null: false
    add_column :subscriptions, :active, :boolean, default: false, null: false
    add_column :subscriptions, :credit_card, :string, null: false
    add_column :subscriptions, :activated_at, :date, null: false
    add_column :subscriptions, :next_payment_at, :date, null: false
  end
end
