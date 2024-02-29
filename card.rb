# frozen_string_literal: true

class Card
  SUIT  = %w[+ <3 ^ <>].freeze
  VALUE = %w[2 3 4 5 6 7 8 9 10 j q k a].freeze

  attr_reader :name, :value, :suit

  def initialize(number)
    @suit  = SUIT[number % 4]
    @value = VALUE[number % 13]
    @name  = value + suit
  end

  def get_score(value)
    return 10 if %w[j q k].include?(value)
    return 11 if value == 'a'

    value.to_i
  end
end
