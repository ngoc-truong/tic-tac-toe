class Player
    attr_accessor :marking

    def initialize(marking)
        @marking = marking
    end
end 

class Board
    attr_accessor :field 

    def initialize
        @field = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end

    def print_board
        puts ""
        i = 0

        3.times do 
            puts " | " + self.field[i].to_s + " | " + self.field[i + 1].to_s + " | " + self.field[i + 2].to_s + " | "
            i += 3
        end

        puts ""
    end

    def update_field(position, marking)
        self.field.map! { |item| item == position ? marking : item }
    end

    def to_arrays_of_three
        new_array = []

        i = 0
        3.times do 
            new_array << [self.field[i], self.field[i + 1], self.field[i + 2]]
            i += 3
        end

        new_array
    end
end

class Game
    attr_accessor :player1, :player2, :board

    def initialize
        @player1 = Player.new("X")
        @player2 = Player.new("O")
        @board = Board.new
    end

    def welcome
        puts ""
        puts "~ Welcome to the fantastic world of Tic-Tac-Toe! ~"
        puts ""
    end

    def start
        self.welcome

        until(self.win?) do
            self.play_one_round
        end

        #if (board_completed?)
        #    return
        #end

        self.ending
    end

    def ending
        self.board.print_board
        puts "Merci pour jouer, monsieuelle!"
    end


    def play_one_round
        puts "Hey, player one, wake up, it's your turn!"
        puts "Player one: Please give me a position."
        self.board.print_board
        position1 = gets.chomp.to_i

        while disallowed_move?(position1) 
            self.board.print_board
            position1 = gets.chomp.to_i
        end

        self.board.update_field(position1, self.player1.marking)

        # If player one wins first
        # ToDo: "Player One has won, yay" will be there two times
        if (self.win?)
            return
        end

        puts "Ok, now it's your turn, player two!"
        puts "Player two: Please give me a position."
        self.board.print_board
        position2 = gets.chomp.to_i

        while disallowed_move?(position2) 
            self.board.print_board
            position2 = gets.chomp.to_i
        end

        self.board.update_field(position2, self.player2.marking)
        self.board.print_board
    end

    def disallowed_move?(position)
        puts "" 
        if self.board.field[position - 1] == self.player1.marking || self.board.field[position - 1] == self.player2.marking 
            puts "Dude, one of you has already chosen this position, duh!"
            puts "Please try again!"
            return true
        end

        if position > 9 || position < 1 
            puts "Hey, man, you cannot choose that position."
            puts "Please try again!"
            return true
        end
        return false
    end

    #ToDo: Does not work yet (after 7 moves the game just quits)
    #def board_completed?
    #    self.board.field.none? { |i| i.is_a? Integer }
    #end

    def win?
        # ToDo: Not sure, why I have to convert to an array again?
        rows = Array(self.get_rows)
        columns = Array(self.get_columns)
        diagonals = Array(self.get_diagonals)

        if three_in_a_row?(rows) || three_in_a_row?(columns) || three_in_a_row?(diagonals)
            return true
        else
            return false 
        end
    end

    def three_in_a_row?(array)
        array.each do |row|
            # ToDo: not sure, why I have to convert to an array again? It's a 2d-array already, so rows should be arrays as well?
            if Array(row).all?(self.player1.marking)            
                puts "Player One has won, yay!"
                return true 
            elsif Array(row).all?(self.player2.marking)
                puts "Player Two has won, yay!"
                return true
            end
        end
        return false
    end

    def get_rows
        self.board.to_arrays_of_three
    end

    def get_columns
        self.board.to_arrays_of_three.transpose
    end

    def get_diagonals
        array = self.get_rows
        diagonals = []
        diagonals << (0..2).collect { |i| array[i][i] } #first diagonal
        
        # second diagonal
        x = 0
        y = 2
        diagonals[1] = []
        3.times do 
            diagonals[1] << array[x][y]
            x += 1
            y -= 1
        end

        return diagonals
    end
end

game = Game.new
game.start
game.board.print_board