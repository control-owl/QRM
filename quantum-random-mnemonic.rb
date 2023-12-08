#!/usr/bin/env ruby
# version 0.2


# Global variables
entropy_file = "entropy/entropy.txt"
portion_size = 256 # bits
wordlist_file = "src/bip39-english.txt"


# Get random portion of the file
def read_random_portion(file_path, portion_size)
  # Get the size of the file
  file_size = File.size(file_path)

  # Generate a random starting point
  random_start = rand(0..(file_size - portion_size))

  # Read the portion of the file
  File.open(file_path, 'rb') do |file|
    file.seek(random_start)
    portion = file.read(portion_size)
    return portion
  end
end

entropy = read_random_portion(entropy_file, portion_size)
puts "256 bit Entropy: #{entropy}",""


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
