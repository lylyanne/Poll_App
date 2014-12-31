class Changepool < ActiveRecord::Migration
  def change
    rename_column :questions, :pool_id, :poll_id
  end
end
