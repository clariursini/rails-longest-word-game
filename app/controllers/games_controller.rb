require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @random_letters = 10.times.map { ('a'..'z').to_a.sample }
  end

  def score
    @guess = params[:word]
    @grid = params[:grid]
    @end_time = Time.now
    @start_time = params[:start_time]

    if word_in_grid_check(@guess, @grid) == true
      if ingles(@guess) == true # word is in english
        score = get_score(@guess, @start_time, @end_time)
        @result = { score: score, message: 'well done' }
      else # word no es en ingles
        @result = { score: 0, message: 'not an english word' }
      end
    else # la palabra no esta en la grilla
      @result = { score: 0, message: 'not in the grid' }
    end
  end

  #   if word_in_grid_check(@guess, @grid) && ingles(@guess, @grid) # las letras que use no estan en el el grid
  #     @score = "La palabra es válida de acuerdo a la cuadrícula y es una palabra en inglés válida"
  #   elsif word_in_grid_check(@guess, @grid)
  #     @score = "La palabra es válida pero no es una palabra en ingles válida"
  #   else
  #     @score = "La palabra no puede crearse a partir de la cuadrícula original"
  #   end
  # end

  # metodo que verifique si la palabra este en la grilla
  def word_in_grid_check(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  # metodo que verifique si es una palabra en ingles (existe la palabra)
  def ingles(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    word_hash = JSON.parse(user_serialized)
    if word_hash['found'] == true
      ingles_check = true
    else
      ingles_check = false
    end
    ingles_check
  end

  # # metodo que calcule solo score
  def get_score(attempt, start_time, end_time)
    score_time = (end_time.to_f - start_time.to_f)
    attempt.size.to_f / score_time
  end
end
