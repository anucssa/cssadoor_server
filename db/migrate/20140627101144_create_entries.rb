class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.timestamps
      t.string :state
    end
  end
end
