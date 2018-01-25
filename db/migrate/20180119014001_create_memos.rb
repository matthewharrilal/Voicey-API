class CreateMemos < ActiveRecord::Migration[5.1]
  def change
    create_table :memos do |t|
      t.string :title
      t.string :date
      t.string :text_body

      t.timestamps
    end
  end
end
