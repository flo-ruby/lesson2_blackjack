# Blackjack
#
# Game
# 1. Have a deck of 52 cards
# 2. Shuffle the cards and make them available one by one from the shoe
# 3. Give 2 cards to the player and 2 cards to the dealer
# 4. Show the player's 2 cards and the first card of the dealer
# 5. Player: give the choice to hit or stay
#   - Hit: deal another card
#       - if greater than 21, player has busted and lost
#       - if 21, player wins
#       - if less than 21, give the choice to the player to hit or stay
#   - Stay: sum the value of the player cards
#   - Show all the player cards
# 6. Dealer: must choose to hit or stay
#   - Same rules as for the player
#   - But under 17, must hit
#   - When does dealer hit?
#       - if < 17
#       - or if dealer points < player points (otherwise, would lose)
# 7. Compare the results of the player and dealer
#
# Method to calculate the sum of the cards
# - Numerical cards are worth the values they show
# - Face cards (kings, queens, jacks) are worth 10
# - Aces are worth 1 or 11
# 1. Sum up the values of the cards
# 2. If one card is an ace:
#   a. Make 2 totals, with the ace worth 1 and worth 11
#   b. Take the highest score that is less or equal to 21
# 3. If two or more cards are aces:
#   - same thing, make all possible totals and take the highest score <= 21
# Method: start with Aces worth 11 and calculate the sum, if it is > 21, then calculate again by removing 10, etc, until the sum is <=21, with the constraint: we have one right to remove 10 for each Ace present in the set of cards.
#
# Structure for the deck of cards
# - each card is identified by 2 infos: value and suit
#   - values taken from: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King
#   - suits taken from: Clubs, Diamonds, Hearts, Spades
# - the 52 cards deck is a combination of all possibilities of values and suits
# Card examples: ["Ace", :spades], ["2", :diamonds]
# Shoe: [["Ace", :spades], ["2", :diamonds],...]

class Card
  attr_accessor :face_value, :suit
  CARD_VALUES = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
  CARD_SUITS = [:clubs, :diamonds, :hearts, :spades]

  def initialize(face_value, suit)
    @face_value = face_value
    @suit = suit
  end

  def points
    case @value
    when "Ace"
      return 11
    when "Jack"
      return 10
    when "Queen"
      return 10
    when "King"
      return 10
    else
      return @value.to_i
    end
  end

  def to_s
    "This is the #{face_value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  def initialize(num_decks)
    @cards = []
    Card::CARD_SUITS.each do |suit|
      Cards::CARD_VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
    @cards = @cards * num_decks
    scramble!
  end

  def scramble!
    cards.shuffle
  end

  def deal
    cards.pop
  end

end

class Hand
end

class PlayerHand < Hand

end

class DealerHand < Hand

end

class Blackjack
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new(2)
  end

  def run
    deal_cards
    show_flow
    player_turn
    dealer_turn
    who_won?
  end
end


# game = Blackjack.new.run
c = Card.new("Ace", :clubs)
puts c
