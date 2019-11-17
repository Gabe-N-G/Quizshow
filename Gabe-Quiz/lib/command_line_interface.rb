require "paint"
require "whirly"
require 'pry'
require "tty-PROMPT"



class CommandLineInterface

    PROMPT = TTY::Prompt.new
    @quitting = false
    def run
        
        greet = PROMPT.yes?('DO YA WANNA PLAY A GAMMEEE?', keys: [:y, :n])
        if greet == true
            name_ask
        elsif greet == false
              endgame
        else 
            return "error"
        end
    end

    def name_ask
        @name = PROMPT.ask("What's ya name, kid?", required: true)
        id_ask
    end

    def id_ask 
        @username = PROMPT.ask("#{@name}? Huh, what a silly name. What would you want to be known as?", required: true)
        # @player = Player.find_by(username: @username)
            id_check
    end

    def id_check
        
        if Player.find_by(username: @username)
            check = PROMPT.yes?("Welcome back #{@username}, continue?")
                if @quitting == true
                    endgame
                elsif check == true
                    select_question
                else
                    id_ask
                end
        else
            Player.create(name: @name, username: @username)
            # @player = Player.find_by(username: @username)
            Whirly.start spinner: "random_dots",  status:  "Creating user data..."
            sleep 1
            Whirly.stop
            Whirly.start spinner: "simpleDotsScrolling",  status:  "Excellllent"
            sleep 1
            Whirly.stop
            if @quitting == true
                endgame
            else   
            select_question
            end
        end
    end

    def select_question 
        # to the people reading this later, this is the part where the program can break every once in a while, I added a rescue clause here and if you find out what question breaks the program it would be wonderful
        first_question = Question.minimum("id")
        total_question = Question.maximum("id")
        @my_question = Question.all[id=rand(first_question..total_question)]
        @player = Player.find_by(username: @username)
        PlayerQuestion.create(player_id: @player.id, question_id: @my_question.id)
        @playerquestion = PlayerQuestion.last
        ask_question
    rescue
        puts "HEY SOMEHING WENT WRONG"
        puts "please report #{@myquestion.last} to the proper authorities!"
        select_question
    end


    def ask_question
        #interesting error here, NOKOGIRI translates my questions from html notation to plaintext, but with one of the answers which uses an accented "o" it fails even if you're right. maybeeeee I need to add nokogiri to the @ask variable?)
        all_answers= [@my_question.incorrect_answer_1, @my_question.incorrect_answer_2, @my_question.incorrect_answer_3, @my_question.correct_answer]
        @ask= PROMPT.select("#{Nokogiri::HTML(@my_question.question_text).text}") do |quiz|
            quiz.choice "#{Nokogiri::HTML(all_answers.delete_at(rand(all_answers.length))).text}"
            quiz.choice "#{Nokogiri::HTML(all_answers.delete_at(rand(all_answers.length))).text}" 
            quiz.choice "#{Nokogiri::HTML(all_answers.delete_at(rand(all_answers.length))).text}"
            quiz.choice "#{Nokogiri::HTML(all_answers.delete_at(rand(all_answers.length))).text}"
        end
            Whirly.start spinner: "bouncingBall",  status:  "Checking your answer..."
            sleep 1
        question_answered
    end


    def question_answered
        Whirly.stop
        if @ask == @my_question.correct_answer
            @playerquestion.correct_questions = true
            @playerquestion.save
            puts "YAYYYYY!!!!"
        else
            puts "Sorry! Try again!"
            puts "The correct answer was #{@my_question.correct_answer}"
        end
        ask_me_another
    end

    def ask_me_another
       
        another = PROMPT.yes?('Want another?')
        if another == true
            Whirly.start spinner: "random_dots",  status:  "Loading new question..."
            sleep 1
            Whirly.stop
        select_question
        else
        endgame
        end
    end

    def endgame #there's definitely some faulty logic here somewhere, especially with the user being able to hit this screen by just saying no to the first prompt. I tried cleaning it up with the quitting variable, but it can defintely crash. ALSO YES I KNOW I INCLUDED FAULTY LOGIC TO MAKE A SAW JOKE (which is a movie that I DIDN'T EVEN FUCKING WATCH)... so sue me.
       
        gamend = PROMPT.select("What would ya want to do then?") do |menu|
            menu.choice 'Check my score!', 1
            menu.choice 'Top 3 players!', 2
            menu.choice 'Delete my data X__X', 3
            menu.choice 'Quit the game :(', 4   
            menu.choice 'WHAT WAS I THINKING I NEED MORE TRIVIA', 5    
            end
            if gamend == 1
                score
            elsif gamend == 2
                top_3
            elsif gamend == 3
                delete
            elsif gamend == 4
                puts "Seeya Loser! :P"
            elsif gamend == 5
                #fix this
                @name = nil
                @username = nil
                quitting = false
                name_ask 
            else    
                "error"
            end

    end    

    def score
        if @username == nil
            puts "You must log in to check your score!!"
            @quitting = 1
            name_ask 
        else
            correct = PlayerQuestion.where(player_id: @player.id, correct_questions: true).count
            avg = correct/PlayerQuestion.where(player_id: @player.id).count.to_f #this doesn't work?
            puts "Hey there #{@username}! You have gotten #{correct} correct answers and have an #{avg.round(3)} average! KEEP AIMING FOR THE TOP!"
            quitting = false
        endgame
        end
    end



    def top_3 #if you guys can help me out with this one that would be lovely.
        puts "STRETCH GOALS BRO. YA GOTTA PAY FOR THIS DLC CONTENT"
    endgame
        # top_3 = {}
        # PlayerQuestion.all.map do |rank, correct|
        #     top_3 = rank.player.id => correct.(correct_questions: true).count
        # binding.pry
        #lists 3 people max_by most correct_questions.
    end

    def delete
       
         del = PROMPT.yes?('Are you sure?', keys: [:y, :n])
            if @username == nil
                puts "You must log in to delete your data!"
                @quitting = true
                name_ask 
         
                elsif del == true
                    Whirly.start spinner: "triangle",  status: "Meet me..."
                    sleep (2)
                    Whirly.stop
                    Whirly.start spinner: "hearts",  status: "at montauk...."
                    @trash = Player.find_by(username: @username)
                    Player.destroy(@trash.id)
                    sleep (1)
                    Whirly.stop
                    puts ":("
                    @quttting = false
                 else
             endgame 
            end
        
     end

end

