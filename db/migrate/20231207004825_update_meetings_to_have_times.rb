class UpdateMeetingsToHaveTimes < ActiveRecord::Migration[7.0]
  def change
    remove_column :meetings, :start_time
    remove_column :meetings, :end_time
    add_column :meetings, :start_time, :time
    add_column :meetings, :end_time, :time
  end
end
