class BooksAuthorsFormats < ActiveRecord::Migration[5.1]
  def change
    create_table :formats do |t|
      t.string name
    end

    create_table :books do |t|
      t.string :title
      t.references :format, index: true
      t.date :release_date
      t.decimal :price, precision: 8, scale: 2
    end

    create_table :authors do |t|
      t.string :name, index: true, unique: true
    end

    create_table :authors_books do |t|
      t.references :author, index: true
      t.references :book, index: true
    end
  end
end
