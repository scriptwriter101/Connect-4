require_relative 'player.rb'

class GameBoard
  attr_accessor :board, :player1, :player2, :turn_number, :options

  def initialize(name1 = 'Player 1', name2 = 'Player 2')
    @board = Array.new(7) { Array.new(6, ' ') }
    @player1 = Player.new(name1, '☯')
    @player2 = Player.new(name2, '☢')
    @turn_number = 1
    @options = [1, 2, 3, 4, 5, 6, 7]
  end

  def play
    puts title
    display
    instructions
    turns
  end

  def title
    " .--.                     .    .---.
:                        _|_   |
|    .-. .--. .--. .-. .-.|    |--- .-. .  . .--.
:   (   )|  | |  |(.-'(   |    |   (   )|  | |
 `--'`-' '  `-'  `-`--'`-'`-'  '    `-' `--`-'   "
  end

  def display
    display_string = "\n"

    5.downto(0) do |row|
      display_string << "+---+---+---+---+---+---+---+\n"
      0.upto(6) do |column|
        display_string << "| #{@board[column][row]} "
      end
      display_string << "|\n"
    end

    display_string << "+---+---+---+---+---+---+---+\n"
    display_string << '  1   2   3   4   5   6   7'

    puts display_string
  end

  def instructions
    print "\nWelcome to Connect Four!
        \nThis is a two player game where you will take turns dropping 'discs' from the top of the board.
        \nWhoever gets four in a row, whether horizontally, vertically, or diagonally, wins!\n"
  end

  def turns
    won = false
    until @turn_number > 42 || won
      turn
      @turn_number += 1
      display
      won = check_for_win
    end
    won ? win : draw
  end

  def turn
    player = @turn_number.even? ? @player2 : @player1
    chosen_column = player.take_turn(@options) - 1
    add_disc(player, chosen_column)
  end

  def add_disc(player, column)
    i = 0
    until @board[column][i] == ' '
      i += 1
    end
    @board[column][i] = player.disc
    @options.delete(column + 1) if i == 5
  end

  def check_for_win
    return true if check_horizontal_wins || check_vertical_wins || check_diagonal_wins
    false
  end

  def check_horizontal_wins
    0.upto(5) do |y|
      0.upto(3) do |x|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x + 1][y] && @board[x + 1][y] == @board[x + 2][y] && board[x + 2][y] == board[x + 3][y]
      end
    end
    false
  end

  def check_vertical_wins
    0.upto(6) do |x|
      0.upto(2) do |y|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x][y + 1] && @board[x][y + 1] == @board[x][y + 2] && @board[x][y + 2] == @board[x][y + 3]
      end
    end
    false
  end

  def check_diagonal_wins
    0.upto(3) do |x|
      0.upto(2) do |y|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x + 1][y + 1] && @board[x + 1][y + 1] == @board[x + 2][y + 2] && @board[x + 2][y + 2] == @board[x + 3][y + 3]
      end

      3.upto(5) do |y|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x + 1][y - 1] && @board[x + 1][y - 1] == @board[x + 2][y - 2] && @board[x + 2][y - 2] == @board[x + 3][y - 3]
      end
    end
    false
  end

  def win
    winner = @turn_number.even? ? @player1.name : @player2.name
    puts "Congratulations #{winner}, you have won this game of Connect Four!"
  end

  def draw
    puts "Oh wow! Both of you either suck or are really good. That's a draw!"
  end
end
