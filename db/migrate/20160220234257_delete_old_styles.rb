class DeleteOldStyles < ActiveRecord::Migration
  def change
    remove_column :beers, :old_style, :string
  end
end
