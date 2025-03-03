class CreateBankStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_statements do |t|
      t.references :user, null: true, foreign_key: true
      t.string :file_data
      t.boolean :parsed, default: false, null: false
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
