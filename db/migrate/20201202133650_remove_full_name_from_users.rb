class RemoveFullNameFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :fullname, :string
  end
end
