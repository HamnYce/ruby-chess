# Frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Pawn
  attr_reader :first_move

  include Piece

  def initialize(team_white)
    # NOTE: if statement for mov_dir (black or white team move different direction)
    # because pawn movement has directionality
    @mov_dir = team_white ? WHITEPAWNPATHS : BLACKPAWNPATHS
    @char_representation = team_white ? WPAWN_ICON : BPAWN_ICON
    @team_white = team_white
    @first_move = true
  end

  def moved
    @first_move = false
  end
end
