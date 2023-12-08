#!/usr/bin/env ruby

# version 0.1

def read_and_convert_to_256_chars(file_path)
  # Read the content of the entropy file
  file_content = File.read(file_path)
  puts "QRNG: #{file_content}",""

  # Convert the text to a 256-character output
  output = file_content.slice(0, 256)

  return output
end

entropy_file = "entropy.txt"
entropy = read_and_convert_to_256_chars(entropy_file)
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
wordlist = File.readlines("wordlist.txt")

# Convert groups of bits to array of words
puts "words:"
sentence = []
pieces.each do |piece|
  i = piece.to_i(2)   # convert string of 11 bits to an integer
  word = wordlist[i]  # get the corresponding word from wordlist
  sentence << word.chomp # add to sentence (removing newline from end of word)
  puts "#{piece} #{i.to_s.rjust(4)} #{word}"
end

mnemonic = sentence.join(" ")
puts "","mnemonic: #{mnemonic}" #=> "punch shock entire north file identify"
