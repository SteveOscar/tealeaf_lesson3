def prompt(msg)
  puts ">>  #{msg}"
end

puts1
prompt "Who should start, (h)uman or (c)omputer?"
answer = gets.chomp.downcase
if answer == 'h'
  current_player = 'human'
elsif answer == 'c'
  current_player = 'computer'
else
  prompt "You should have chosen 'h' or 'c', now the computer will start."
  current_player = 'computer'
  prompt "Hit 'enter' to begin"
  gets
end

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagnols
human_score = 0
computer_score = 0

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |   #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |   #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |   #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop: enable Metrics/AbcSize

def joinor(array)
  list = []
  array.each do |item|
    if array.index(item) == (array.length - 2)
      list.push(item.to_s + ' or')
    else
      list.push(item.to_s)
    end
  end
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = ' ' }
  new_board
end

def player_move!(brd)
  loop do
    prompt 'Please select a square:'
    square = gets.chomp.to_i
    if brd[square] != ' ' || square > 9 || square < 1
      prompt 'Invalid choice, try again...'
    else
      brd[square] = 'X'
      break
    end
  end
end

def computer_move!(brd)
  if brd[5] == ' '
    brd[5] = 'O'
    prompt "Computer chooses square 5"
  else
    computer_offense!(brd)
  end
end

def computer_offense!(brd)
  square = 0
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count('O') == 2
      square = line.select { |a| brd[a] == ' ' }.join.to_i
      if brd[square] == ' '
        brd[square] = 'O'
        prompt "Computer chooses square #{square}"
      end
    end
  end
  if square == 0
    computer_defense!(brd)
  end
end

def computer_defense!(brd)
  square = 0
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count('X') == 2
      square = line.select { |a| brd[a] == ' ' }.join.to_i
      if brd[square] == ' '
        brd[square] = 'O'
        prompt "Computer chooses square #{square}"
      end
    end
    break if square != 0
  end
  if square == 0
    computer_turn!(brd)
  end
end

def computer_turn!(brd)
  loop do
    square = rand(1..9)
    if brd[square] == ' '
      brd[square] = 'O'
      prompt "Computer chooses square #{square}"
      break
    end
  end
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == ' ' }
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def winner?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count('X') == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count('O') == 3
      return 'Computer'
    end
  end
  nil
end

def place_peice!(brd, player)
  if player == 'human'
    player_move!(brd)
  else
    computer_move!(brd)
  end
end

def alternate_player(player)
  if player == 'human'
    current_player = 'computer'
  elsif player == 'computer'
    current_player = 'human'
  end
end

loop do
  board = initialize_board

  loop do
    display_board(board)
    prompt "Human: #{human_score}, Computer: #{computer_score}"
    prompt "Valid choices include #{joinor(empty_squares(board))}"
    place_peice!(board, current_player)
    current_player = alternate_player(current_player)
    break if winner?(board) || board_full?(board)
  end

  display_board(board)

  if winner?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie..."
  end

  prompt 'End of Game!'
  puts

  if detect_winner(board) == "Player"
    human_score += 1
  elsif detect_winner(board) == "Computer"
    computer_score += 1
  end

  if human_score == 5 || computer_score == 5
    break
  end

  prompt 'Hit enter to begin the next round...'
  gets.chomp
end

prompt 'Thanks for playing'
puts
