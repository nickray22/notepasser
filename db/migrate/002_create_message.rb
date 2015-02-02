class CreateMessage < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :recipient_id
      t.text :content
      t.boolean :read_status
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :messages
  end
end
