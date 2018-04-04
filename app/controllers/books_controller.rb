class BooksController < ApplicationController
  before_action -> { @formats = Format.all }

  def index
    @books = Book.all.order('title')
  end

  def new
    @book = Book.new(release_date: Date.today)
  end

  def create
    book_params = params[:book]
    book = Book.new
    book.title = book_params[:title]
    book.price = book_params[:price]
    book.release_date = Date.strptime(book_params[:release_date], '%m/%d/%Y')
    book.format = Format.find(book_params[:format], )
    author_ids = params[:author_ids].split(',').map(&:to_i).reject(&:zero?)
    Book.transaction do |t|
      author_ids.each do |aid|
        book.authors << Author.find(aid)
      end
      if book.save
        redirect_to books_path
      else
        @book = book
        render 'new'
        raise ActiveRecord::Rollback
      end
    end
  end

  def edit

  end

  def update

  end

  def show

  end

end