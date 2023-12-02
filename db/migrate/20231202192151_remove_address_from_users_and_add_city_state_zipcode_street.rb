class RemoveAddressFromUsersAndAddCityStateZipcodeStreet < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zipcode, :string
    add_column :users, :street, :string
  end
end
