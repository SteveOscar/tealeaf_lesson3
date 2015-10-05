# Tic Tac Toe
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagnols

def prompt(msg)
  puts ">>  #{msg}"
end

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

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = ' ' }
  new_board
end

def player_turn!(brd)
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
    # if brd[line[0]] == 'X' && brd[line[1]] == 'X' && brd[line[2]] == 'X'
    #   return 'Player'
    # elsif brd[line[0]] == 'O' && brd[line[1]] == 'O' && brd[line[2]] == 'O'
    #   return 'Computer'
    # end
    if brd.values_at(line[0], line[1], line[2]).count('X') == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count('O') == 3
      return 'Computer'
    end
  end
  nil
end

loop do
  board = initialize_board

  loop do
    display_board(board)
    prompt "Valid choices include #{empty_squares(board).join(', ')}"
    player_turn!(board)
    break if winner?(board) || board_full?(board)
    computer_turn!(board)
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

  prompt 'Play again?'
  answer = gets.chomp.downcase
  break unless answer.start_with?('y')
end

puts
prompt 'Thanks for playing'
puts
