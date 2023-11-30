class CreateMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :meetings do |t|
      t.date :date
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :is_accepted
      t.string :purpose

      t.timestamps
    end
  end
end
