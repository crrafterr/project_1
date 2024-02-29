# frozen_string_literal: true

require_relative 'menu'
require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'player'

class Game
  attr_accessor :player, :players, :dealer, :deck, :menu, :bank

  DEALER_NAME = Dealer
  BET = 20
  ROUND_ACTION = { '1' => 'skip', '2' => 'add_card', '3' => 'open_card' }.freeze

  def initialize
    @menu = Menu.new
    @players = []
  end

  def main
    init_game
    loop do
      start_game
      continue = menu.get_user_input('Continue? (yes/no)')
      break if continue == 'no'
    rescue StandardError => e
      break puts e
    end
  end

  def init_game
    name = menu.get_user_input('Enter your name')
    players << self.player = Player.new(name)
    players << self.dealer = Dealer.new(DEALER_NAME)
    self.deck = Deck.new
  end

  def start_game
    deal_cards
    place_bet
    start_round
    show_winner
    reset_cards
  end

  def deal_cards
    raise 'There are not enough cards in the deck to continue the game' if deck.cards.length < 6

    players.each { |p| p.cards += deck.take_card(2) }
  end

  def place_bet
    players.each(&:place_bet)
    self.bank = BET
  end

  def start_round
    loop do
      menu.show_round_menu(players)
      break open_card if player.cards.length == 3 && dealer.cards.length == 3

      menu.show_menu(menu.round_menu)
      number = menu.get_user_input('Enter action number')
      break action_selection(number) if number == '3'

      action_selection(number)
    end
  end

  def action_selection(number)
    method(ROUND_ACTION[number]).call
  end

  def skip
    dealer.cards += deck.take_card(1) if chek_cards(dealer)
  end

  def add_card
    player.cards += deck.take_card(1) if chek_cards(player)
    dealer.cards += deck.take_card(1) if chek_cards(dealer)
  end

  def chek_cards(player)
    return player.cards.length < 3 if player.instance_of?(Player)

    dealer.score <= 17 && dealer.cards.length < 3 if player.instance_of?(Dealer)
  end

  def open_card
    menu.print_strip('Game result')
    players.each { |p| menu.show_game_results(p) }
  end

  def show_winner
    winner = choose_winner
    menu.show_winner(winner_name(winner))
    get_winnings(winner)
  end

  def choose_winner
    return 'draw' if chek_draw
    return player if player.score <= 21 && dealer.score > 21
    return dealer if player.score > 21 && dealer.score <= 21
    return player if player.score > dealer.score

    dealer if player.score < dealer.score
  end

  def chek_draw
    return true if player.score == dealer.score

    true if player.score > 21 && dealer.score > 21
  end

  def winner_name(winner)
    return winner if winner == 'draw'

    winner.name
  end

  def get_winnings(winner)
    if winner == 'draw'
      players.each { |i| i.add_many(bank / 2) } if winner == 'draw'
    else
      winner.add_many(bank)
    end
    self.bank = 0
  end

  def reset_cards
    players.each { |i| i.cards = [] }
  end
end

Game.new.main
