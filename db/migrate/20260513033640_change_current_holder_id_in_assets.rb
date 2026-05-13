class ChangeCurrentHolderIdInAssets < ActiveRecord::Migration[8.1]
  def change
    change_column_null :assets, :current_holder_id, true
  end
end
