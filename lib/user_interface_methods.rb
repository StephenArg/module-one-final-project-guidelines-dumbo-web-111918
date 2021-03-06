
def home_logo
  system 'clear'
  system "echo '>< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><' | lolcat -a -d 2 -s 10"
  system "echo"
  system "echo '>< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><' | lolcat -a -d 2 -s 10"
  system "echo"
  system "echo '>< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><' | lolcat -a -d 2 -s 10"
  system "echo"
  system "artii DANK TRIVIA | lolcat -a -s 100"
  system "echo '>< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><' | lolcat -a -d 2 -s 10"
  system "echo"
  system "echo '>< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><' | lolcat -a -d 2 -s 10"
  system "echo"
  system "echo '>< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><' | lolcat -a -d 2 -s 10"
end

def logo
  system 'clear'
  system "artii DANK TRIVIA | lolcat"
end

def tty_home
  home_logo
  system "say 'Welcome to Dank Trivia'"
  TTY::Prompt.new.select("Welcome to Dank Trivia".red.bold) do |menu|
    menu.choice "Login" => -> do tty_login end
    menu.choice "Create User" => -> do tty_create_user end
    menu.choice "Quick Play" => -> do tty_guest end
    menu.choice "High Scores 🇯🇲" => -> do high_scores end
    menu.choice "Close Program".red => -> do abort("See you later dude.") end
  end
end

def tty_create_user
  logo
  new_name = TTY::Prompt.new.ask("Enter your name --->") do |q|
    q.validate(/^[a-zA-Z ]{3,20}$/, "Name must be between 3 and 20 characters and only letters and can contain spaces")
  end
  new_username = TTY::Prompt.new.ask("Enter a Username --->") do |q|
    q.validate(/^\A[a-z0-9_]{4,10}\z$/, "Username must contain 4-10 characters of lower_case letters and / or numbers")
  end
  new_password = TTY::Prompt.new.mask("Enter a Password --->") do |q|
    q.validate(/^\A[a-z0-9_]{5,10}\z$/, "Password must be between 5-10 characters and can contain letters and numbers")
  end
  $user = User.create(name:new_name, username: new_username, password: new_password, best_harvest: 0, kernel_wallet: 0)
  tty_new_user_main_menu
end

def tty_guest
  username = "anonymous"
  password = "foenrgjnglj33"
  $user = User.find_by(username: username, password:password)
  tty_guest_main_menu
end

def tty_login
  logo
  username = TTY::Prompt.new.ask("Enter Username --->")
  password = TTY::Prompt.new.mask("Enter Password --->")
  $user = User.find_by(username: username, password:password)
  if $user == nil
    TTY::Prompt.new.select("That username or password does not exist.".light_red.blink) do |menu|
      menu.choice "Try again?".green => -> do tty_login end
      menu.choice "I quit. Take me home.".light_red => -> do tty_home end
      end
  else
    tty_main_menu
  end
end

def tty_guest_main_menu
  system 'say "Ok fast boi, lets go"'
  new_game
end

def tty_new_user_main_menu
  phrase = ["Welcome to the club, #{$user.name}", "Welcome to dank trivia. Only rule... No talking about dank trivia", "I am your father", "I do nott, get, french toast", "do not leave me like all the others", "You can call me daaddy"]
  logo
  system "say '#{phrase.sample}'"
  TTY::Prompt.new.select("Welcome to D A N K  t r i v i a. when you're here, #{$user.name}, you're family!") do |menu|
    menu.choice "Play New Game" => -> do new_game end
    menu.choice "Log out" => -> do tty_home end
  end
end

def tty_main_menu
  logo
  system "say 'yo dog, welcome back'"
  TTY::Prompt.new.select("Welcome back #{$user.name}") do |menu|
    menu.choice "Play New Game" => -> do new_game end
    menu.choice "Check my High Score" => -> do my_high_score end
    menu.choice "Log Out" => -> do tty_home end
    menu.choice "Close Program" => -> do abort("See you later dude.") end
  end
end

def new_game
  logo
  difficulty = TTY::Prompt.new.select("Choose your difficulty".cyan) do |menu|
    menu.choice "easy"
    menu.choice "medium"
    menu.choice "hard"
    menu.choice "any"
  end
  difficulty_speach(difficulty)

  logo
  q_amount = TTY::Prompt.new.select("How many questions?".cyan) do |menu|
    menu.choice 10
    menu.choice 20
    menu.choice 30
  end.to_i
  q_amount_speach(q_amount)

  $voice_on = TTY::Prompt.new.select("Would you like questions to use text-to-speech?") do |menu|
    menu.choice "yes"
    menu.choice "heck yes"
    menu.choice "no"
  end

  if difficulty == "any"
    $user.create_game(q_amount)
  else
    $user.create_game_by_difficulty(q_amount, difficulty)
  end
  play_game
end

def play_game
  quotes = [
    "You gotta water your plants. Nobody can water them for you.",
    "I put cocoa butter all over my face and my iconic belly and my arms and legs. Why live rough? Live smooth.",
    "Congratulations. You played yourself",
    "They dont want us to win",
    "The key is to make it.",
    "They will try to close the door on you, just open it.",
    "Baby, you smart. I want you to film me taking a shower.",
    "They dont want you to win. They dont want you to have the number one record in the country... They dont want you to get healthy... They dont want you to exercise... And they dont want you to have that view.",
    "Bless up."
  ]

  all_questions.each do |gq|
    logo
    if $voice_on == "no"
      ask_question(gq)
    else
      ask_question_voice(gq)
    end
    sleep(0.3)
    TTY::Prompt.new.select("<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>".magenta) do |menu|
      menu.choice "next question"
      menu.choice "anotha' one 🙏"
      menu.choice "anotha' one 🙏 🔑"
      menu.choice "We da best".light_cyan.blink => -> do

        quote = quotes.sample
        TTY::Prompt.new.say("#{quote} - DJ Khalid".light_cyan)
        system "say #{quote}"
        abort()
      end
    end
  end
  end_screen
end

def all_questions
  $game = $user.games.last
  q_list = $game.questions_in_current_game
  q_list
end

def say_question(question_instance)
  fixed_question = question_instance.question.gsub("'",'').gsub('"',"")
  system "say '#{fixed_question}'"
  nil
end

def ask_question_voice(gq)
  question_instance = Question.find(gq.question_id)
  question_options = [question_instance.correct_answer,question_instance.option1,
    question_instance.option2, question_instance.option3].shuffle
  value = TTY::Prompt.new.select("#{question_instance.question.light_cyan}#{say_question(question_instance)}") do |option|
    option.choice question_options[0]
    option.choice question_options[1]
    option.choice question_options[2]
    option.choice question_options[3]
  end
  if value == question_instance.correct_answer
    gq.update(correct?: true)
    TTY::Prompt.new.say("Correct!! Good job, goober!@!".green)
    system "say 'Correct!'"
  else
    gq.update(correct?: false)
    TTY::Prompt.new.say("Wrong answer, champ!".light_yellow)
    system "say 'Wrong answer champ!'"
    TTY::Prompt.new.say("Correct answer was '#{question_instance.correct_answer}'...".light_red)
  end
end

def ask_question(gq)
  question_instance = Question.find(gq.question_id)
  question_options = [question_instance.correct_answer,question_instance.option1,
    question_instance.option2, question_instance.option3].shuffle
  value = TTY::Prompt.new.select(question_instance.question.light_cyan) do |option|
    option.choice question_options[0]
    option.choice question_options[1]
    option.choice question_options[2]
    option.choice question_options[3]
  end
  if value == question_instance.correct_answer
    gq.update(correct?: true)
    TTY::Prompt.new.say("Correct!! Good job, goober!@!".green)
  else
    gq.update(correct?: false)
    TTY::Prompt.new.say("Wrong answer, champ!".light_yellow)
    TTY::Prompt.new.say("Correct answer was '#{question_instance.correct_answer}'...".light_red)
  end
end

def end_screen
  $user.best_score?
  TTY::Prompt.new.ok("You obtained #{$game.score} kernels of truth. Gratz!".yellow)
  TTY::Prompt.new.ok("In other words: you got #{$game.raw_score} right.")
end

def high_scores
  system 'clear'
  high_scores_list = Game.score_list.first(5)
  table = TTY::Table.new ["Username", "Kernels"], high_scores_list
  puts table.render(:ascii, alignments: [:center, :center], padding: [1,1]).yellow
  TTY::Prompt.new.ask("Press enter to return to the main menu".red)
  tty_home
end

def my_high_score
  TTY::Prompt.new.say("Your best harvest was #{$user.best_harvest} kernels.")
  TTY::Prompt.new.say("Your kernel wallet currently has #{$user.kernel_wallet} kernels of truth")
  sleep 1
  system "say 'Your best harvest was #{$user.best_harvest} kernels of truth.'"
  TTY::Prompt.new.ask("Press enter to return to your home screen".red)
  tty_main_menu
end

def difficulty_speach(difficulty)
  if difficulty == 'easy'
    phrase = ["not dank", "no es moy calliennte", "dang", "what are you, a baby?", "you can not handle the sauce", "Baby, baby, baby. O"]
    system "say '#{phrase.sample}'"
  elsif difficulty == 'medium'
    phrase = ["alright, solid choice", "not bad", "trust the sauce", "you make me feel so young", "like, totally"]
    system "say '#{phrase.sample}'"
  elsif difficulty == 'hard'
    phrase = ["dank", "thats ganster", "moy calliennte", "ok, lets see how good you really are hotshot", "dang", "wow, someones confident"]
    system "say '#{phrase.sample}'"
  else
    phrase = ["living on the edge, thats dank", "ahh, just like in the old country", "ANYTHING"]
    system "say '#{phrase.sample}'"
  end
end

def q_amount_speach(q_amount)
  if q_amount == 10
    phrase = ["only ten?", "only ten? woooooow", "really? only ten?", "do you have somewhere to be?", "i would like a small order of questions. hold the mayo"]
    system "say '#{phrase.sample}'"
  elsif q_amount == 20
    phrase = ["niceee", "you look niceee today", "are you working out?", "seriously, are you working out?", "thicc"]
    system "say '#{phrase.sample}'"
  else
    phrase = ["you are a champion of the people", "we are going to be here for a while", "hope you like hearing, what is love, eighteen times in a row."]
    system "say '#{phrase.sample}'"
  end
end


def play_again?
  TTY::Prompt.new.select("Would you like to play again?") do |menu|
    menu.choice "Sure" => -> do tty_main_menu end
    menu.choice "Fo sure" => -> do tty_main_menu end
    menu.choice "Abso-freaking-lutely" => -> do tty_main_menu end
    menu.choice "No. Take me home.".light_magenta => -> do
      system "say 'Okay. Wimp'"
      tty_home
    end
  end
end
