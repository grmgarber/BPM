class BooksController < ApplicationController
  before_action -> { @formats = Format.all }

  def index
    @books = Book.all.order('lower(title)')
  end

  def new
    @book = Book.new(release_date: Date.today)
    @book_authors = []
  end

  def create
    book = Book.new
    author_ids = assign_params_return_author_ids(book, params)
    author_ids.each { |aid| book.authors << Author.find(aid) }
    if book.save
      redirect_to books_path
    else
      @book = book
      @book_authors = book.authors_for_client
      render 'new'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @book_authors = @book.authors_for_client
  end

  def update
    @book = Book.find(params[:id])
    update_authors
    if @book.save
      flash[:notice] = 'Product successfully updated'
      redirect_to books_path
    else
      @book_authors = @book.authors_for_client
      flash.now[:alert] = 'Please fix the problems below and re-try'
      render 'edit'
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def report
    @books = Book.report view_context.report_year, view_context.report_format_id
  end

  private

  def assign_params_return_author_ids(book, params)
    book_params = params[:book]
    book.title = book_params[:title]
    book.price = book_params[:price]
    if book_params[:release_date].present?
      book.release_date = Date.strptime(book_params[:release_date])
    end
    book.format = Format.find(book_params[:format])
    params[:author_ids].split(',').map(&:to_i).reject(&:zero?)
  end

  def update_authors
    author_ids = assign_params_return_author_ids(@book, params)
    unless author_ids == @book.authors.pluck(:id).to_a
      @book.authors = Author.none
      author_ids.each { |aid| @book.authors << Author.find(aid) }
    end
  end
end