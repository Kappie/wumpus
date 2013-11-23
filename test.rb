require "open3"
require "strscan"


def game(seed, *args)
  Open3.popen3("ruby bin/wumpus #{seed}") do |stdin, stdout, stderr, wait_thr|
    args.flatten.each { |e| stdin.puts(e) }
    
    stdin.close

    StringScanner.new(stdout.read)
  end
end

def move(num)
  ["m", num]
end

def shoot(num)
  ["s", num]
end

def bats_test
  commands = [ move(3),  # bats are heard 
               move(2),  # bats move us to room 7
               move(4),  # move into another room
               move(14), # bats are now at 14 because that's where they brought us to before
             ]

  output = game(999, commands)


  fail "Bats are broken!" unless output.scan_until(/rustling/) &&
                                 output.scan_until(/whisk/) &&
                                 output.scan_until(/whisk/)

  puts "BATS OK"
end

def pits_test
  commands = [ move(5), # pit is sensed 
               move(6)  # player falls into pit 
             ]

  output = game(999, commands)

  fail "Pits are broken!" unless output.scan_until(/wind/) &&
                                 output.scan_until(/fell/)

  puts "PITS OK"
end

def wumpus_killer_test
  commands = [ move(5), # smell the stanky beast 
               shoot(1) # kill him!
             ]

  output = game(999, commands)

  fail "Wumpus killing broken!" unless output.scan_until(/smell/) &&
                                       output.scan_until(/YOU KILLED/)


  puts "WUMPUS KILL OK"
end

def death_by_wumpus_test
  commands = [ move(5), # smell the stanky beast 
               move(1)   # bump into him
             ]

  output = game(999, commands)

  fail "Death by wumpus broken!" unless output.scan_until(/smell/) &&
                                        output.scan_until(/ate you/)


  puts "MURDED BY WUMPUS OK"
end

def misfire_test
  commands = [ move(5),
               shoot(6)
             ]

  output = game(999, commands)

  fail "Misfire broken!" unless output.scan_until(/arrow missed/)

  puts "MISFIRE OK"
end


bats_test
pits_test
wumpus_killer_test
death_by_wumpus_test
misfire_test
