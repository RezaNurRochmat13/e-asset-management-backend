class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.references :location, null: false, foreign_key: true
      t.references :current_holder, null: true, foreign_key: { to_table: :users }

      t.string :asset_code, null: false
      t.string :serial_number
      t.string :name, null: false
      t.string :description
      t.string :asset_type # e.g., laptop, monitor, etc.
      t.string :status, default: "active" # e.g., active, inactive, archived, in_use, available, maintenance, retired
      t.string :asset_image_url

      t.decimal :acquisition_cost, precision: 15, scale: 2, default: 0.0
      t.decimal :salvage_value, precision: 15, scale: 2, default: 0.0
      t.integer :useful_life # useful life in years for depreciation calculations

      t.date :buy_date
      t.date :tax_date
      t.text :notes
      t.text :remarks

      t.timestamps
    end
    add_index :assets, :asset_code, unique: true
    add_index :assets, :serial_number, unique: true
  end
end
