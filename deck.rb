# frozen_string_literal: true

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    (0..51).each { |i| @cards << Card.new(i) }
    cards.shuffle!
  end

  def take_card(number = 1)
    cards.pop(number)
  end
end
