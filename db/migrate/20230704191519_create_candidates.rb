class CreateCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates do |t|
      t.string :name, null: false
      t.string :campaign_name, references: :campaigns, null: false

      t.timestamps
    end

    add_foreign_key :candidates, :campaigns, column: 'campaign_name', primary_key: 'name'
  end
end
