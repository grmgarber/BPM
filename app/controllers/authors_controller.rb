class AuthorsController < ApplicationController
  # Return authors that match the query pattern
  def index
    authors = Author.where('name LIKE ?', "%#{params['term']}%").order(:name)
    render json: authors.map { |e| { id: e.id, value: e.name } }
  end
end