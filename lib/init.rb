# Frozen_string_literal: true

require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

# might convert board 8x8 array to hash (same logic)
# might store some information in a hash (king positions maybe?)
STARTING_BOARD = Array.new(8) { Array.new(8, nil) }

# Black's side
STARTING_BOARD[0][0] = Rook.new(false)
STARTING_BOARD[0][1] = Bishop.new(false)
STARTING_BOARD[0][2] = Knight.new(false)
STARTING_BOARD[0][3] = Queen.new(false)
STARTING_BOARD[0][4] = King.new(false)
STARTING_BOARD[0][5] = Kight.new(false)
STARTING_BOARD[0][6] = Bishop.new(false)
STARTING_BOARD[0][7] = Rook.new(false)
# initialise black pawns
(0..7).each { |i| STARTING_BOARD[1][i] = Pawn.new(false) }

# White's side
STARTING_BOARD[7][0] = Rook.new(true)
STARTING_BOARD[7][1] = Bishop.new(true)
STARTING_BOARD[7][2] = Knight.new(true)
STARTING_BOARD[7][3] = Queen.new(true)
STARTING_BOARD[7][4] = King.new(true)
STARTING_BOARD[7][5] = Kight.new(true)
STARTING_BOARD[7][6] = Bishop.new(true)
STARTING_BOARD[7][7] = Rook.new(true)
# initialise white pawns
(0..7).each { |i| STARTING_BOARD[7][i] = Pawn.new(true) }