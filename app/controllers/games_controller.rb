require 'open-uri'

class GamesController < ApplicationController

  def new
    @random_letters = 10.times.map { ('a'..'z').to_a.sample }
  end

  def score
    @guess = params[:word]
    @grid = params[:grid]
    @start_time = Time.new
    @end_time = Time.new

    if word_in_grid_check(@guess, @grid) && ingles(@guess, @grid) # las letras que use no estan en el el grid
      @score = "La palabra es válida de acuerdo a la cuadrícula y es una palabra en inglés válida"
    elsif word_in_grid_check(@guess, @grid)
      @score = "La palabra es válida pero no es una palabra en ingles válida"
    else
      @score = "La palabra no puede crearse a partir de la cuadrícula original"
    end
  end

  # metodo que verifique si la palabra este en la grilla
  def word_in_grid_check(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  # metodo que verifique si es una palabra en ingles (existe la palabra)
  def ingles(attempt, grid)
    # API Check
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    word_hash = JSON.parse(user_serialized)
    if word_hash["found"] == true
      ingles_check = true
    else
      ingles_check = false
    end
    return ingles_check
  end

  # # Calculating the time
  # def calculate_time(start_time, end_time)
  #   total_time = end_time - start_time
  #   return total_time
  # end

  # # metodo que calcule solo score
  # def get_score(attempt, grid, start_time, end_time)
  #   score_time = calculate_time(start_time, end_time).to_f
  #   score = attempt.size.to_f / score_time
  #   return score
  # end

    # # recibe el scrore(metodo anterior) y te da el mensaje (llama a los 3 otros metodos)
    # def run_game(attempt, grid, start_time, end_time)
    #   if word_in_grid_check(attempt, grid) == true
    #     if ingles(attempt, grid) == true # word is in english
    #       score = get_score(attempt, grid, start_time, end_time)
    #       { time: calculate_time(start_time, end_time), score: score, message: "well done" }
    #     else # word no es en ingles
    #       { time: calculate_time(start_time, end_time), score: 0, message: "not an english word" }
    #     end
    #   else # la palabra no esta en la grilla
    #       { time: calculate_time(start_time, end_time), score: 0, message: "not in the grid" }
    #   end
    # end
end
