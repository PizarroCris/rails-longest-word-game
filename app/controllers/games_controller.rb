require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase

    if !valid_word_from_grid?(@word, @letters)
      @result = "Sorry but #{@word} can't be built out of #{@letters.join(", ")}"
      @points = 0
    elsif !english_word?(@word)
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
      @points = 0
    else
      @result = "Congratulations! #{@word} is a valid English word!"
      @points = @word.length
    end

    session[:score] ||= 0
    session[:score] += @points
    @total_score = session[:score]
  end

  private

  def valid_word_from_grid?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  rescue StandardError
    false
  end
end
