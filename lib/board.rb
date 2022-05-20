# frozen_string_literal: true

require_relative 'init'
require_relative 'pieces/piece'
require_relative 'movement'
require_relative 'serializer'
require_relative 'simulator'
require_relative 'checker'
require_relative 'gui'
require_relative 'board_helper'

# insert_documentation_here
class Board
  include Serializer
  include Simulator
  include Checker
  include Gui
  include BoardHelper

  def initialize
    @table = STARTINGBOARD
    @wking_pos = STARTWHITEKING
    @bking_pos = STARTBLACKKING
    @curr_player_white = true
    print_table
    turn
  end

  # TODO: add regex for input
  def turn
    # 'fast forwarding the game to pawn upgrade position'
    inputs = 'e2 e4/a7 a6/e4 e5/f7 f6/e5 f6/a6 a5/f6 g7/a5 a4/'
    inputs.split('/').each do |inp|
      x = inp.split(' ')
      move(parse(x[0]), parse(x[1]))
    end
    # ----

    puts "enter e to exit or positions to move from/to\nformat: a1 a2"
    input = gets.chomp

    load_game if input == 'l'

    until input[-1] == 'e'
      input = input.split
      init_pos = parse(input[0])
      fin_pos = parse(input[1])

      status = move(init_pos, fin_pos)

      if status == 'Checkmate!'
        print_table
        return 'game ended'
      else
        puts status
      end

      puts 'input:'
      input = gets.chomp

      save_game if input[0] == 'se'
    end

    puts 'game ended'
  end

  # NOTE: converts from chess notation to pos notation
  def parse(input)
    input = input.split('').reverse
    input[0] = 8 - input[0].to_i
    input[1] = input[1].ord - 97
    input
  end

  def move(init_pos, fin_pos)
    # change phases into methods

    # Phase 1 conditions
    return response('no piece') unless piece_exists?(init_pos)

    piece = @table[init_pos[0]][init_pos[1]]
    # Phase 2 conditions
    return response('wrong team') if piece.team_white != @curr_player_white

    dir = direction(init_pos, fin_pos)

    return response('no dir') unless piece.can_move?(dir)

    p_moves = piece_moves(piece, init_pos, dir)

    # Phase 3 conditions
    return response('not legal') unless p_moves.include?(fin_pos)
    return response('friendly fire') if same_team?(piece, get_piece(fin_pos))
    return response('rogue pawn') if piece.pawn? && !legal_pawn_move?(fin_pos, dir)

    simulate(init_pos, fin_pos)


    # Phase 4 conditions
    if under_attack?(current_king_pos, !@curr_player_white)
      revert_simulation
      return response('self check')
    end

    if piece.pawn?
      piece.moved
      upgrade_pawn(fin_pos, @curr_player_white) if pawn_reached_end?(fin_pos)
    end

    # Phase 5 conditions
    return 'Checkmate!' if checkmate?


    flip_current_player

    # maybe move system('clear') into the print function
    system('clear')
    print_table

    'successful move'
  end

  def pawn_reached_end?(pos)
    @curr_player_white && pos[0] == 0 || !@curr_player_white && pos[0] == 7
  end

  # FIXME: input validation
  def upgrade_pawn(pos, team)
    print_upgrade_screen(team)
    c = gets.chomp.to_i
    new_piece = case c
               when 1
                Queen.new(team)
               when 2
                Rook.new(team)
               when 3
                Bishop.new(team)
               when 4
                Knight.new(team)
               else
                @table[pos[0]][pos[1]]
               end

    @table[pos[0]][pos[1]] = new_piece
  end
end

b = Board.new
