class AuthorsController < ApplicationController
  TOO_MANY = 20
  TOO_MANY_MESSAGE = '* Enter additional characters for a shorter list *'.freeze

  # Return authors that match the query pattern
  def index
    authors = Author.where('name LIKE ?', "%#{params['term']}%").order(:name)
    authors = authors.map { |e| { id: e.id, value: e.name } }
    authors << { id: -1, value: TOO_MANY_MESSAGE } if authors.size >= TOO_MANY
    render json: authors
  end
end