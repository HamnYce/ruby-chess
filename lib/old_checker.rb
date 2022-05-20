# frozen_string_literal: true

def linear_check(defender_pos, directions, att_team)
  # get the first piece in a given direction
  all_moves = directions.map { |dir| possible_moves(defender_pos, dir).last }
  all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
  all_moves.map! { |pos| get_piece(pos) }

  all_moves.each do |piece|
    # if piece is opposite team and appropriate piece then defender_piece is
    # under attack
    if (piece.queen? || (piece.rook? && directions == STRAIGHTPATHS) ||
      (piece.bishop? && directions == DIAGPATHS)) &&
      (piece.team_white == att_team)
      return true
    end
  end

  false
end

def knight_check(defender_pos, att_team)
  all_moves = KNIGHTPATHS.map { |dir| possible_move(defender_pos, dir).last }
  all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
  all_moves.map! { |pos| get_piece(pos) }

  all_moves.each do |piece|
    return true if piece.team_white == att_team && piece.knight?
  end

  false
end

def pawn_check(defender_pos, att_team)
  directions = @curr_player_white ? WHITEPAWNATTPATHS : BLACKPAWNATTPATHS

  all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }
  all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
  all_moves.map! { |pos| get_piece(pos) }

  all_moves.each do |piece|
    return true if piece.team_white == att_team && piece.pawn?
  end

  false
end

def king_check(defender_pos, att_team)
  all_moves = KINGPATHS.map { |dir| possible_move(defender_pos, dir).last }
  all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
  all_moves.map! { |pos| get_piece(pos) }

  all_moves.each do |piece|
    return true if piece.team_white == att_team && piece.king?
  end

  false
end