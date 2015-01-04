class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.text :request_url
      t.integer :response_code
      t.string :ip
      t.text :response_text
      t.text :params

      t.timestamps
    end
  end
end
