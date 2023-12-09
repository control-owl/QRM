#!/usr/bin/env ruby
# version 0.3


# Global variables
entropy_file = "entropy/entropy.txt"
wordlist_file = "src/bip39-english.txt"


# Using zenity for GUI dialogs
def show_menu(length)
  option_bit = [
    "128-bit 12",
    "256-bit 24"
  ]

  # Create a command string to execute zenity with a list dialog
  zenity_command = "zenity --width=500 --height=500 --list --title='QRM' --text='Select the entropy length' --column='Entropy length' --column='Seed length in words' #{option_bit.join(' ')}"

  # Execute the command and capture the selected option
  selected_option = `#{zenity_command}`.chomp

  case selected_option
  when "128-bit"
    entropy_length = 128
    puts "Entropy length: #{entropy_length}-bit",""
    return entropy_length
  when "256-bit"
    entropy_length = 256
    puts "Entropy length: #{entropy_length}-bit",""
    return entropy_length
  else
    puts "You canceled or closed the dialog"
    exit
  end
end

# Call the method to show the menu
entropy_length = show_menu(entropy_length)


# Get random portion of the file
def read_random_portion(file_path, entropy_length)
  # Get the size of the file
  file_size = File.size(file_path)

  # Generate a random starting point
  random_start = rand(0..(file_size - entropy_length))

  # Read the portion of the file
  File.open(file_path, 'rb') do |file|
    file.seek(random_start)
    portion = file.read(entropy_length)
    return portion
  end
end

entropy = read_random_portion(entropy_file, entropy_length)
puts "#{entropy_length}-bit Entropy: #{entropy}",""


# Create checksum
require 'digest'
size = entropy.length / 32 # number of bits to take from hash of entropy (1 bit checksum for every 32 bits entropy)
sha256 = Digest::SHA256.digest([entropy].pack("B*")) # hash of entropy (in raw binary)
checksum = sha256.unpack("B*").join[0..size-1] # get desired number of bits
puts "Entropy checksum: #{checksum}",""


# Combine
full = entropy + checksum
puts "Entropy and Checksum combined: #{full}",""


# Split in to strings of of 11 bits
pieces = full.scan(/.{11}/)


# Get the wordlist as an array
wordlist = File.readlines(wordlist_file)


# Convert groups of bits to array of words
puts "words:"
sentence = []
pieces.each do |piece|
  i = piece.to_i(2)   # convert string of 11 bits to an integer
  word = wordlist[i]  # get the corresponding word from wordlist
  sentence << word.chomp # add to sentence (removing newline from end of word)
  puts "#{piece} #{i.to_s.rjust(4)} #{word}"
end

# Show mnemonic
mnemonic = sentence.join(" ")
puts "","mnemonic: #{mnemonic}" #=> "punch shock entire north file identify"
