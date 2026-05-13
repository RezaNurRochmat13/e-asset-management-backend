class CreateAssetLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_logs do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.string :action, null: false # e.g., "created", "updated",
      t.text :remarks

      t.timestamps
    end
  end
end
