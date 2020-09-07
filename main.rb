# Let's coding: UTF-8 


class HangmanGame

  @@word_list = ['egg', 'banana', 'rabbit', 'apple', 'walkman']


  def initialize(word_list = @@word_list)
    @word_list = word_list
    @total_score = 0
  end

  def game_begin
    puts "Welcome to Hangman Game. Press enter to continue. To quit type 'q'."

    quit = gets.chomp
    exit_game if quit == 'q' || quit == 'Q'

    waiting = lambda do
      print '.'
      sleep(1)
    end

    @alphabet = [*('a'..'z')]
    @entered_letters = ''      #letters which user's entered

    @point = 0
    @lives = 10

    puts 'Game is beginning'
    3.times {waiting.call}

    select_word   # selects a random word from the '@word_list'

    puts "\nNew game started... your word is #{ @word.size } characters long"
    puts "To exit game at any point type 'exit'\n "

  end

  def game_end(state)
    @total_score += @point

    #If the user did not win, placeholder is filled.
    @word.size.times {|i| @word_placeholder[i] = @word[i]} if @lives == 0


    puts state
    print_word_placeholder

    puts "Your score was :#{@point}"
    puts "Press enter to continue..." ; gets

  end

  def select_word
    @word = @word_list.sample
    @word_placeholder = "#{'_'* @word.size}"

  end

  def change_point(value)
    @point += value
  end

  def print_word_placeholder
    puts 'The word is:'
    @word_placeholder.each_char {|i| print i + ' '}
    puts "\n "

  end

  def print_all
    puts "▾"*50
    puts "Point : #{@point}"
    puts "You have #{ @lives } lives left. Try again! \n "

    print_word_placeholder   # prints word's placeholder like '_ _ _ _ _'

    #this block print alphabet except entered letters
    @alphabet.each_with_index do |letter, i|
      if @entered_letters.include?(letter)
        print '[X]'
      else
        print letter
      end

      print "\t"
      puts if (i+1) % 6 == 0

    end

    puts "\n"*2, 'Type a letter'
    puts "▴"*50, ""

  end

  def check_letter(letter)
    letter = letter.downcase
    exit_game if letter == 'exit'

    guess_status = false
    @exist_letter_count = 0

    return 'nochr' if ([letter] & @alphabet) == []            # checking whether "letter" is a letter
    return 'duplicate' if @entered_letters.include?(letter)   # checking whether "letter" has been entered before

    @entered_letters += letter				                        # adding entered letter to @entered_letters
    @entered_letters.chars.sort.join  			                  # sorting `@entered_letters` string


    @word.size.times do |i|
      if letter == @word[i]
        @word_placeholder[i] = @word[i]
        @exist_letter_count += 1

        change_point(50)
        guess_status = true unless guess_status
      end
    end

    return guess_status

  end

  def start
    while true
      game_begin

      while true
        print_all

        letter = gets.chomp
        guess_status = check_letter(letter)


        if guess_status == 'nochr'
          puts "==> Wrong input! Please type only letter."
          change_point(-10)
          next
        elsif guess_status == 'duplicate'
          puts "==> The letter '#{letter}' has already been entered."
          change_point(-5)
          next
        elsif guess_status == false
          @lives -= 1
          change_point(-20)

          if @lives == 0
            game_state = "Game over"
            break
          end

        else
          puts "There is #{@exist_letter_count} '#{letter}' in word .. \n",
               "You earned #{@exist_letter_count * 50} points."

          if @word == @word_placeholder
            game_state = "\n", "⭐"*30, "Congratulations... You won the game ⛄"
            break
          end

        end  # main if condition (checking guess_status)


      end   # while loop

      game_end(game_state)
    end


  end

  def exit_game
    puts "Thanks for playing. Your score is :#{@total_score}"
    sleep(3)
    exit
  end

  
end




h1 = HangmanGame.new
h1.start
