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

require "pry"

class Card
  attr_accessor :face_value, :suit
  CARD_VALUES = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
  CARD_SUITS = [:clubs, :diamonds, :hearts, :spades]

  def initialize(face_value, suit)
    @face_value = face_value
    @suit = suit
  end

  def points
    case @face_value
    when "Ace"
      return 11
    when "Jack"
      return 10
    when "Queen"
      return 10
    when "King"
      return 10
    else
      return @face_value.to_i
    end
  end

  def to_s
    "#{face_value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  def initialize(num_decks)
    @cards = []
    Card::CARD_VALUES.each do |face_value|
      Card::CARD_SUITS.each do |suit|
        @cards << Card.new(face_value, suit)
      end
    end
    @cards = @cards * num_decks
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end
end

module Hand
  def pretty_hand
    cards.map do |card|
      "#{card}"
    end.join(", ")
  end

  def number_of_aces
    cards.select do |card|
      card.face_value == "Ace"
    end.count
  end

  def total
    card_values = cards.map do |card|
      card.points
    end
    v = card_values.reduce(:+)
    n = number_of_aces
    while (v > 21) && (n > 0)
      v = v - 10
      n = n - 1
    end
    return v
  end

  def deals(deck)
    @cards << deck.deal_one
  end

  def hits(deck)
    puts "Hitting..."
    @cards << deck.deal_one
    show_cards
  end

  def stays
    puts "Staying..."
  end
end

class Player
  include Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def plays(deck)
    loop do
      player_points = self.total
      if player_points > 21
        puts "\nYou have #{player_points} points. That is more than 21! Dealer wins."
        exit
      elsif player_points == 21
        puts "\nWow, you got 21! You made the blackjack and you win!"
        exit
      end
      puts "Hit or Stay? (h/s)"
      answer = gets.chomp.downcase
      if answer == "h"
        self.hits(deck)
      else
        self.stays
        break
      end
    end
  end

  def show_cards
    puts "Your cards: #{pretty_hand}"
  end
end

class Dealer
  include Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def plays(deck)
    loop do
      sleep(2)
      dealer_points = self.total
      if dealer_points > 21
        puts "\nDealer has #{dealer_points} which is more than 21. You win!"
        exit
      elsif dealer_points == 21
        puts "\nDealer has 21. Dealer wins."
        exit
      end
      if dealer_points < 17
        self.hits(deck)
      else
        self.stays
        break
      end
    end
  end

  def show_cards
    puts "Dealer cards: #{pretty_hand}"
  end
end

class Blackjack
  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new(1)
  end

  def run
    deal_cards
    show_initial_cards

    player_total = player_turn
    puts ""
    dealer_total = dealer_turn
    
    who_won(player_total, dealer_total)
  end

  def deal_cards
    player.deals(deck)
    dealer.deals(deck)
    player.deals(deck)
    dealer.deals(deck)
  end

  def show_initial_cards
    puts "Dealer visible card is: #{dealer.cards[1]}"
    player.show_cards
  end

  def player_turn
    player.plays(deck)
    player_total = player.total
    puts "Your points: #{player_total}."
    return player_total
  end

  def dealer_turn
    dealer.show_cards
    dealer.plays(deck)
    dealer_total = dealer.total
    puts "Dealer points: #{dealer_total}."
    return dealer_total
  end

  def who_won(player_total, dealer_total)
    if player_total > dealer_total
      puts "\nYou have more points than the dealer. You win!"
    elsif player_total < dealer_total
      puts "\nDealer has more points. Dealer wins."
    else
      puts "\nIt's a tie."
    end
  end
end

game = Blackjack.new.run
