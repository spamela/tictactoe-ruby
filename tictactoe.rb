###############################################################################
## Project: TicTacToe implementation
## Created by: Pamela Nunez
## Completed: March 16, 2014
## Description: Text-based TicTacToe game with (almost) perfect AI.
## AI wins in most cases, except when user plays first and chooses boxes 0 and 8.
###############################################################################

class TicTacToe
    attr_accessor :ai, :player, :gameend, :round, :total, :gameboard, :input, :winner

    def initialize
        @ai = ""
        @player = ""
        @gameend = 0	#Will be 1 when the game is over
        @round = 0	
        @total = 0		#Total possible wins for 1 player. Used to check for forks
        @gameboard = Array.new(3) { [" ", " ", " "] } #Store grid marks
        @input = ""		#Most recent user input
        @winner = ""	#Stores the winner or "tie" if there is a tie
    end

	#Initial game display
    def gameBegin 
        puts "Welcome to TicTacRuby!"
        puts "Please select your symbol. X goes first, O goes second. "

        @player = gets.chomp #Ensure valid X/O user input
        while @player !~ /[XO]/ do
            puts "Invalid input! Please enter X or O: "
            @player = gets.chomp
        end

        if @player == "X" then #X always goes first
            @ai = "O"
            puts "You will play as X, you will play first."
        else
            @ai = "X"
            puts "You will play as O, you will play second."
        end
        puts ""
        puts "Enter your symbol by indicating the position"
        puts "you prefer with the following numbers:"
        puts ""
        puts "0|1|2"
        puts "-+-+-"
        puts "3|4|5"
        puts "-+-+-"
        puts "6|7|8"
        puts ""
        puts "You may quit the game at any time by entering \"exit\"."
        puts ""
        puts "Round #{0}"
        puts ""
        puts "#{@gameboard[0][0]}|#{@gameboard[0][1]}|#{@gameboard[0][2]}"
        puts "-+-+-"
        puts "#{@gameboard[1][0]}|#{@gameboard[1][1]}|#{@gameboard[1][2]}"
        puts "-+-+-"
        puts "#{@gameboard[2][0]}|#{@gameboard[2][1]}|#{@gameboard[2][2]}"
        puts ""
    end

	#Display current board and round
    def turnInit(sym)
        puts "Round #{@round}: #{sym}"
        puts ""
        puts "#{@gameboard[0][0]}|#{@gameboard[0][1]}|#{@gameboard[0][2]}"
        puts "-+-+-"
        puts "#{@gameboard[1][0]}|#{@gameboard[1][1]}|#{@gameboard[1][2]}"
        puts "-+-+-"
        puts "#{@gameboard[2][0]}|#{@gameboard[2][1]}|#{@gameboard[2][2]}"
        puts ""
    end

    def turnInput
        puts "Please enter you choice: "
 
        @input = gets.chomp
        while @input.to_i < 0 || @input.to_i > 8 || @input =~ /\D|^$/
            if @input.downcase == "exit"
                puts "Thanks for playing!"
                exit
            else
                puts "Invalid input! Please enter a number between 0 and 8: "
                @input = gets.chomp
            end
        end

        puts "You have entered #{@input}."
        puts ""
    end

    def userTurn(fill)
        r = 0
        c = 0
        if @input.to_i <= 2 then
            c = @input.to_i
        elsif @input.to_i > 2 && @input.to_i <= 5
            r = 1
            c = @input.to_i - 3
        elsif @input.to_i > 5
            r = 2
            c = @input.to_i - 6
        end
        
        if @gameboard[r][c] != " " then 
            return false
        else 
            @gameboard[r][c] = @player if fill
            @round+=1 if fill
            return true
        end
    end

    def run 
        if (@gameend == 0) then
         if @player == "X" then
            turnInput 
            while userTurn(false) == false do
                puts "That space is already filled!"
                turnInput
            end
            userTurn(true)
            turnInit(@player)
            checkGameEnd(@player)
            if @gameend == 1 then return true end
            
            aiTurn
            turnInit(@ai)
            checkGameEnd(@ai)
          elsif @player == "O" then
            aiTurn
            turnInit(@ai)
            checkGameEnd(@ai)
            
            if @gameend == 1 then return true end
            turnInput 
            while userTurn(false) == false do
                puts "That space is already filled!"
                turnInput
            end
            userTurn(true)
            turnInit(@player)
            checkGameEnd(@player)
          end
        elsif (@gameend == 1)
            puts "Thank you for playing!"
            exit
        end
    end

#Checks for a possible winning move, the fill param allows me to choose whether 
#I want to fill in a winning move or just check for one
    def winningMove(winner, loser, fill)
        @total = 0 #will store number of possible win locations
        row1 = @gameboard[0]
        row2 = @gameboard[1]
        row3 = @gameboard[2]
        col1 = []
        col2 = []
        col3 = []
        col1 << @gameboard[0][0] << @gameboard[1][0] << @gameboard[2][0]
        col2 << @gameboard[0][1] << @gameboard[1][1] << @gameboard[2][1]
        col3 << @gameboard[0][2] << @gameboard[1][2] << @gameboard[2][2]
        diag1 = []
        diag2 = []
        diag1 << @gameboard[0][0] << @gameboard[1][1] << @gameboard[2][2]
        diag2 << @gameboard[0][2] << @gameboard[1][1] << @gameboard[2][0]
        rows = [row1, row2, row3]
        cols = [col1, col2, col3]
        diag = [diag1, diag2]
        winning = [] #store winning row/col/diags
        rows.each do |row|
            #check if row contains opponent, and if there are two of player in row
            if !row.include?(loser) && row.count(winner) == 2 then
                row.fill(winner) if fill    #fills winning row if fill param == true
                checkGameEnd(winner)    #forces game end
                winning << row
                @total+=1
            end
        end
        cols.each do |col|
            if !col.include?(loser) && col.count(winner) == 2 then
                #if total is already 1, won't add another entry
                #admittedly, not totally sure why saying "if fill" isn't enough
                (for i in 0..2 do col[i].replace(winner) end) if (fill && @total == 0)
                checkGameEnd(winner)
                winning << col
                @total+=1
            end
        end
        diag.each do |dia|
            if !dia.include?(loser) && dia.count(winner) == 2 then
                (for i in 0..2 do dia[i].replace(winner) end) if (fill && @total == 0)
                winning << dia
                @total+=1
            end
        end
        if winning.count == 0
            #returns false if there are no possible wins
            false
        else
            #returns first possible winning spot. Might make this randomly chosen
            winning[0]
        end
    end

#Check for or create forks, which are combinations where there are two possible wins
    def fork(current, opponent, fill, block)
        curcount = 0
        oppcount = 0
        @gameboard.each { |ary| curcount += ary.count(current) }
        @gameboard.each { |ary| oppcount += ary.count(opponent) }
        if winningMove(current, opponent, false) == false && curcount < 4 then
            for r in 0..2
                for c in 0..2
                    if @gameboard[r][c] == " " then
                        @gameboard[r][c] = current #temp. assign spot to check for fork
                        winningMove(current, opponent, false) #call to update total
                        if @total > 1 then
                            @gameboard[r][c] = " " if !fill
                            @gameboard[r][c] = @ai if block
                            return true
                        else
                            #if total <= 1, then no possible forks, so undo test value
                            @gameboard[r][c] = " "
                            result = false
                        end
                    end
                end
            end
        end
        result
    end

    def oppositeCorner(current, opponent)
        #According to strategy, mark should go in opposite corner of opponent's
        cors = [@gameboard[0][0], @gameboard[2][2], @gameboard[0][2], @gameboard[2][0]]
        if cors[0] == current && cors[1] == " " then
            cors[1] = current
            return true
        elsif cors[2] == current && cors[3] == " " then
            cors[3] = current
            return true
        elsif cors[3] == current && cors[2] == " " then
            cors[2] = current
            return true
        elsif cors[1] == current && cors[0] == " " then
            cors[0] = current
            return true
        #Fill an empty corner if opponent does not have any corner
        elsif cors.include?(" ") then
            cors.keep_if { |x| x == " " }
            cors[rand(cors.length)].replace(current)
            return true
        else
            return false
        end
    end

    def fillSide(current, opponent)
        #Fill an empty side slot
        sides = [@gameboard[0][1], @gameboard[1][0], @gameboard[1][2], @gameboard[2][1]]
        sides.keep_if { |x| x == " " }
        sides[rand(sides.length)].replace(current) if !sides.empty?
        return true
    end
    
    def aiTurn
        #This method calls the various move methods in order of best strategy
        #Try to make a winning move
        if winningMove(@ai, @player, true) != false && @gameend == 0 then 
            @round+=1
            return true
        end
        
        #Try to block a winning move
        if winningMove(@player, @ai, false) != false && @gameend == 0 then
            block = winningMove(@player, @ai, false)
            block[block.find_index(" ")].replace(@ai)
            @round+=1
            return true
        end
        
        #Try to make a fork
        if fork(@ai, @player, true, false) && @gameend == 0 then 
            @round+=1
            return true
        end
        
        #Try to block a fork
        if fork(@player, @ai, true, true) && @gameend == 0 then 
            @round+=1
            return true
        end
        
        #Try to fill the center
        if @gameboard[1][1] == " " && @gameend == 0 then
            @gameboard[1][1] = @ai
            @round+=1
            return true
        end

        #Try to fill an opposite corner
        #Try to fill a randomly selected empty corner if none are filled
        if oppositeCorner(@ai, @player) && @gameend == 0 then
            @round+=1
            return true
        end
        
        #Try to fill an empty side if no corners are available
        if @gameend == 0 then
            @round+=1
            fillSide(@ai, @player)
        end
    end

    def checkGameEnd(sym)
        #Checks if three in a row has been achieved
        if @gameboard[0][0] == sym && @gameboard[1][1] == sym &&
            @gameboard[2][2] == sym then
            @gameend = 1
            @winner = sym
        elsif @gameboard[0][2] == sym && @gameboard[1][1] == sym &&
            @gameboard[2][0] == sym then
            @gameend = 1
            @winner = sym
        else
            for i in 0..2
                if @gameboard[i][0] == sym && @gameboard[i][1] == sym && 
                    @gameboard[i][2] == sym then
                    @gameend = 1
                    @winner = sym
                end
                if @gameboard[0][i] == sym && @gameboard[1][i] == sym && 
                    @gameboard[2][i] == sym then
                    @gameend = 1
                    @winner = sym
                end
            end
        end
        #Check for a tie
        if @gameend == 0 then
            filled = true
            @gameboard.each { |ary| if ary.include?(" ") then filled = false end }
            if filled then @gameend = 1; @winner = "tie" end
        end
    end

    #Display final game
    def gameEndDisplay
        if @gameend == 1 && @winner == "" then
            puts "Thanks for playing!"
        else
            puts "Final board:"
            puts ""
            puts "#{@gameboard[0][0]}|#{@gameboard[0][1]}|#{@gameboard[0][2]}"
            puts "-+-+-"
            puts "#{@gameboard[1][0]}|#{@gameboard[1][1]}|#{@gameboard[1][2]}"
            puts "-+-+-"
            puts "#{@gameboard[2][0]}|#{@gameboard[2][1]}|#{@gameboard[2][2]}"
            puts ""
            if @winner == @player
                puts "You're the winner! Congratulations!"
            elsif @winner == @ai
                puts "Sorry, I win! Better luck next time!"
            elsif @winner == "tie"
                puts "It's a tie!"
            end
            puts "Thanks for playing!"
        end
    end

end

    game = TicTacToe.new    #Create instance of TicTacToe game
    game.gameBegin()        #Display initial message
    while (game.gameend == 0)&&(game.input.downcase != "exit")
        #Run game until gameend flag is triggered
        game.run
    end
    game.gameEndDisplay     #Display final message


