class BooksController < ApplicationController
  before_action -> { @formats = Format.all }

  def index
    @books = Book.all.order('title')
  end

  def new
    @book = Book.new(release_date: Date.today)
    @book_authors = []
  end

  def create
    book_params = params[:book]
    book = Book.new
    book.title = book_params[:title]
    book.price = book_params[:price]
    if book_params[:release_date].present?
      book.release_date = Date.strptime(book_params[:release_date])
    end
    book.format = Format.find(book_params[:format])
    author_ids = params[:author_ids].split(',').map(&:to_i).reject(&:zero?)
    Book.transaction do
      author_ids.each do |aid|
        book.authors << Author.find(aid)
      end
      if book.save
        redirect_to books_path
      else
        @book = book
        @book_authors = book.authors_for_client
        render 'new'
        raise ActiveRecord::Rollback
      end
    end
  end

  def edit
    @book = Book.find(params[:id])
    @book_authors = @book.authors_for_client
  end

  def update
    book_params = params[:book]
    book = Book.find(params[:id])
    book.title = book_params[:title]
    book.price = book_params[:price]
    book.release_date = (Date.strptime(book_params[:release_date]) rescue nil)
    book.format = Format.find(book_params[:format])
    author_ids = params[:author_ids].split(',').map(&:to_i).reject(&:zero?)
    Book.transaction do
      unless author_ids.sort == book.authors.pluck(:id).to_a.sort
        book.authors = Author.none
        author_ids.each { |aid| book.authors << Author.find(aid) }
      end
      if book.save
        redirect_to books_path
      else
        @book = book
        @book_authors = book.authors_for_client
        render 'edit'
        # raise ActiveRecord::Rollback
      end
    end
  end

  def show
    @book = Book.find(params[:id])
  end
end