class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.string :style
      t.string :brewery_id

      t.timestamps null: false
    end
  end
end
