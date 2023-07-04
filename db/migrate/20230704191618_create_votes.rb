class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.string :campaign_name, references: :campaigns, null: false
      t.references :candidate, null: false, foreign_key: true
      t.string :validity, null: false
      t.datetime :voted_at, null: false

      t.timestamps
    end

    # https://www.fatlemon.co.uk/2018/08/foreign-keys-to-custom-primary-key-caveats-in-ruby-on-rails/
    add_foreign_key :votes, :campaigns, column: 'campaign_name', primary_key: 'name'
  end
end
