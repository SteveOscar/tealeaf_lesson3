def prompt(msg)
  puts ">>  #{msg}"
  puts
end

cards = [['H', '2'], ['H', '3'], ['H', '4'], ['H', '5'], ['H', '6'],
         ['H', '7'], ['H', '8'], ['H', '9'], ['H', '10'], ['H', 'J'],
         ['H', 'Q'], ['H', 'K'], ['H', 'A'], ['D', '2'], ['D', '3'],
         ['D', '4'], ['D', '5'], ['D', '6'], ['D', '7'], ['D', '8'],
         ['D', '9'], ['D', '10'], ['D', 'J'], ['D', 'Q'], ['D', 'K'],
         ['D', 'A'], ['C', '2'], ['C', '3'], ['C', '4'], ['C', '5'],
         ['C', '6'], ['C', '7'], ['C', '8'], ['C', '9'], ['C', '10'],
         ['C', 'J'], ['C', 'Q'], ['C', 'K'], ['C', 'A'], ['S', '2'],
         ['S', '3'], ['S', '4'], ['S', '5'], ['S', '6'], ['S', '7'],
         ['S', '8'], ['S', '9'], ['S', '10'], ['S', 'J'], ['S', 'Q'],
         ['S', 'K'], ['S', 'A']]

player_hand = []
player_values = []
player_total = 0
dealer_hand = []
dealer_values = []
dealer_total = 0

def initialize_deck(cards)
  new_deck = cards
  new_deck
end

def deal_player!(dk, p_hand)
  2.times do
    card = dk.sample
    p_hand << card
    dk.delete(card)
  end
end

def deal_dealer!(dk, d_hand)
  2.times do
    card = dk.sample
    d_hand << card
    dk.delete(card)
  end
end

def hit!(dk, hand)
  card = dk.sample
  hand << card
  dk.delete(card)
end

def hand_values(hnd, values)
  hnd.each do |card|
    values << card[1]
  end
end

def hand_total(values)
  total = 0
  values.each  do |card|
    if card == 'J' || card == 'Q' || card == 'K'
      total += 10
    elsif card == 'A'
      if (total + 11) < 22
        total += 11
      else
        total += 1
      end
    else
      total += card.to_i
    end
  end
  total
end

def resolution(p_total, d_total)
  if d_total > 21 && p_total < 22
    prompt "Dealer busts, you win"
  elsif d_total > p_total && d_total < 22
    prompt "Dealer wins, you lose..."
  elsif d_total < p_total && p_total < 22
    prompt "You win!"
  elsif p_total == d_total
    prompt "Tie game..."
  end
end

# Deals the firs set of cards and updates totals
deck = initialize_deck(cards)
deal_player!(deck, player_hand)
hand_values(player_hand, player_values)
deal_dealer!(deck, dealer_hand)
hand_values(dealer_hand, dealer_values)
player_total += hand_total(player_values)
dealer_total += hand_total(dealer_values)

# Player's turn loop
puts
prompt "The dealer is showing #{dealer_hand[1]}"
loop do
  if player_total > 21
    prompt "You busted, dealer wins"
    break
  else
    prompt "Your cards: #{player_hand}"
    prompt "Player total = #{player_total}, will you (h)it or (s)tay?"
    answer = gets.chomp.downcase
    if answer == 'h'
      player_values = []
      hit!(deck, player_hand)
      hand_values(player_hand, player_values)
      player_total = hand_total(player_values)
    elsif answer == 's'
      break
    else
      prompt "Enter either 'h' to hit, or 's' to stay..."
    end
  end
end

# Dealer's turn loop
if player_total < 22
  while dealer_total < 17
    prompt "Dealer has #{dealer_total} and will hit. Press 'enter' to continue."
    gets
    dealer_values = []
    hit!(deck, dealer_hand)
    hand_values(dealer_hand, dealer_values)
    dealer_total = hand_total(dealer_values)
  end
  prompt "Dealer has #{dealer_total}, Player has #{player_total}"
else
  prompt "Dealer has #{dealer_total}, Player has #{player_total}"
  prompt "You busted, dealer wins..."
end

resolution(player_total, dealer_total)

prompt "END OF GAME"
