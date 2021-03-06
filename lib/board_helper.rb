# frozen_string_literal: true

require_relative 'movement'

module BoardHelper
  include GroupedMovementProcs
  include MovementAlgorithms

  # DOC: returns direction (symbol)
  def direction(init_pos, fin_pos)
    direction = ''
    vertical = fin_pos[0] - init_pos[0]
    horizontal = fin_pos[1] - init_pos[1]

    if vertical.positive? then direction += 'DOWN'
    elsif vertical.negative? then direction += 'UP'
    end

    if horizontal.positive? then direction += 'RIGHT'
    elsif horizontal.negative? then direction += 'LEFT'
    end

    direction.to_sym
  end

  def upgrade_pawn(pos, team)
    c = -1

    until c.between?(1, 4)
      print_upgrade_screen(team)
      c = gets.chomp.to_i
    end

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

  def pawn_reached_end?(pos)
    @curr_player_white && pos[0] == 0 || !@curr_player_white && pos[0] == 7
  end

  def legal_pawn_move?(fin_pos, dir)
    (DIAGPATHS.include?(dir) && piece_exists?(fin_pos)) ||
      (%i[UP DOWN].include?(dir) && !piece_exists?(fin_pos))
  end

  def same_team?(a_piece, b_piece)
    return false if b_piece.nil?

    a_piece.team_white == b_piece.team_white
  end

  def get_piece(pos)
    @table[pos[0]][pos[1]]
  end

  def flip_current_player
    @curr_player_white = !@curr_player_white
  end

  def current_king_pos
    @curr_player_white ? @wking_pos : @bking_pos
  end

  def other_king_pos
    @curr_player_white ? @bking_pos : @wking_pos
  end

  def update_curr_king_pos(new_pos)
    if @curr_player_white
      @wking_pos = new_pos
    else
      @bking_pos = new_pos
    end
  end
end
