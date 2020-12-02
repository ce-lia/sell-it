class AddCategoryToCLassifieds < ActiveRecord::Migration[6.0]
  def change
    add_column :classifieds, :category, :string
  end
end
