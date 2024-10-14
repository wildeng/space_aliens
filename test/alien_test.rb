# frozen_string_literal: true

require_relative 'helper'

class AlienTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @alien = Alien.new(@window, 100, 100, :green)
  end

  def test_alien_initialization
    assert_equal 100, @alien.x
    assert_equal 100, @alien.y
    assert_equal :right, @alien.direction
  end

  def test_alien_move
    @alien.move(5)
    assert_equal 105, @alien.x

    @alien.direction = :left
    @alien.move(5)
    assert_equal 100, @alien.x
  end

  def test_alien_drop
    @alien.drop(5)
    assert_equal 105, @alien.y
  end
end
