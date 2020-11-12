class RemoveConstraintInClassifieds < ActiveRecord::Migration[6.0]
  def change
    change_column :classifieds, :user_id, :integer, :null => true
  end
end
