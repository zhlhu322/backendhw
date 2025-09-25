class AddEndDateToMissions < ActiveRecord::Migration[8.0]
  def change
    add_column :missions, :end_date, :datetime
  end
end
