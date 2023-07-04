class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns, id: false, primary_key: :name  do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.timestamps
    end
  end
end
