# frozen_string_literal: true

# contains methods to look for check on a given piece
module Checker
  def linear_check(defender_pos, directions)
    # for each direction we get the last possible movement using
    # possible_moves & last
    # this gives us an array with positions that should either be an empty
    # space next to a wall or occupied by a piece
    all_moves = directions.map { |dir| possible_moves(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }

    puts "all: #{all_moves}"
    all_moves.each do |attacker_pos|
      # skip if no piece at pos
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      # if piece is opposite team and appropriate piece then defender_piece is
      # under attack
      if (piece.queen? || (piece.rook? && directions == STRAIGHTPATHS) ||
        (piece.bishop? && directions == DIAGPATHS)) && other_team?(piece)
        return true
      end
    end

    false
  end

  def knight_check(defender_pos)
    all_moves = KNIGHTPATHS.map { |dir| possible_move(defender_pos, dir).last }

    all_moves.compact.each do |attacker_pos|
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      return true if other_team?(piece) && piece.knight?
    end

    false
  end

  def pawn_check(defender_pos)
    directions = @curr_player_white ? WHITEPAWNATTPATHS : BLACKPAWNATTPATHS

    all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }

    all_moves.compact.each do |attacker_pos|
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      return true if other_team?(piece) && piece.pawn?
    end

    false
  end
end
