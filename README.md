## Reqs

- jq
- xxd
- ruby
- zenity


## Steps:

1. Go to https://qrng.anu.edu.au/random-binary 
2. Start generating quantum random numbers 
3. Let the website run for a long time !!!! It will generated very long binary string but you will only see a trimmed version of it 
4. To select **whole output**, triple-click on a binary string
5. Copy output to local file "entropy/binary.qrn"


## Start script with:

```
ruby quantum-random-mnemonic.rb
```

## What will happens?

1. Script will read a specific portion of a entropy file, starting from a random position
2. Then it will convert it to a mnemonic words
