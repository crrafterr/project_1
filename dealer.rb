# frozen_string_literal: true

class Dealer
  attr_accessor :name, :bank, :cards

  MANY = 100

  def initialize(name)
    @name = name
    @bank = MANY
    @cards = []
  end

  def show_cards
    cards_name = []
    cards.each { |card| cards_name << card.name }

    cards_name
  end

  def score
    score = 0
    i = 0
    cards.each do |card|
      score += card.get_score(card.value)
      score -= 10 if i.positive? && card.value == 'a' && score > 21
      i += 1
    end

    score
  end

  def place_bet
    raise "#{name} no has money to bet" if bank < 10

    self.bank -= 10
  end

  def add_many(sum)
    self.bank += sum
  end
end
