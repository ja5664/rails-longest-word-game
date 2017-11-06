require 'open-uri'

class GamesController < ApplicationController
  def new
    # Generating a random array and selecting letters from it
    @grid_size = 12
    @grid_letters = []
    letters = ("A".."Z").to_a
    @grid_size.times { @grid_letters << letters.sample }
    @grid_letters
  end

  def score
    @time_taken = (Time.now - Time.parse(params[:start_time])).round(2)
    @attempt = params[:attempt]
    @grid_letters = params[:letters]
    @english_word = word_in_dictionary(@attempt)
    if words_in_grid?
       message_and_score(word_in_dictionary(@attempt)['found'])
    else
      @message = "uses letters which were not on the grid"
      @score = 0
    end
  end

  def words_in_grid?
    @attempt.upcase.split("").all? { |char| @grid_letters.include?(char) && @attempt.upcase.count(char) <= @grid_letters.count(char) }
  end

  def message_and_score(result_of_dictionary_check)
    if result_of_dictionary_check
      time_taken = @time_taken
      @message = "is an english word"
      @score = ((@attempt.length / time_taken)*100).to_i
    else
      @message = "is not an english word"
      @score = 0
    end
  end

  def word_in_dictionary(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    wagon_dict_read = open(url).read
    JSON.parse(wagon_dict_read)
  end
end
