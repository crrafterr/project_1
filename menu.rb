# frozen_string_literal: true

class Menu
  ROUND_MENU = ['Skip', 'Add cart', 'Open card'].freeze

  attr_reader :round_menu

  def initialize
    @round_menu = ROUND_MENU
  end

  def get_user_input(message)
    puts message
    gets.chomp
  end

  def show_cards(player)
    puts "#{player.name} cards: #{player.show_cards}" if player.instance_of?(Player)
    puts "#{player.name} cards: [*****]" if player.instance_of?(Dealer)
  end

  def show_score(player)
    puts "#{player.name} score: #{player.score}" if player.instance_of?(Player)
  end

  def show_game_results(player)
    puts "#{player.name} cards: #{player.show_cards}, sum: #{player.score}"
  end

  def print_strip(name)
    puts "######## #{name} ########"
  end

  def show_menu(menu)
    i = 1
    menu.each do |item|
      puts "#{i}. #{item}"
      i += 1
    end
  end

  def show_winner(name)
    return puts 'You played in a draw' if name == 'draw'

    puts "Winner: #{name}"
  end

  def show_round_menu(players)
    print_strip('Round progress')
    players.each do |p|
      show_cards(p)
      show_score(p) if p.instance_of?(Player)
    end
  end
end
