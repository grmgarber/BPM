# There was a typo in the :formats table def
class FixFormatsTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :formats
    create_table :formats do |t|
      t.string :name
    end
  end

  def down; end
end
