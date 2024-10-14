# frozen_string_literal: true

require_relative 'helper'

class SpaceshipTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @spaceship = Spaceship.new(@window)
  end

  def test_spaceship_initialization
    assert_equal (@window.width - @spaceship.width) / 2, @spaceship.x
    assert_equal @window.height - @spaceship.height - 10, @spaceship.y
  end

  def test_spaceship_movement
    initial_x = @spaceship.x

    @spaceship.move_left
    assert_equal initial_x - 5, @spaceship.x

    @spaceship.move_right
    assert_equal initial_x, @spaceship.x
  end

  def test_spaceship_boundary
    @spaceship = Spaceship.new(MockWindow.new(100, 100))

    20.times { @spaceship.move_left }
    assert_equal 0, @spaceship.x

    20.times { @spaceship.move_right }
    assert_equal 100 - @spaceship.width, @spaceship.x
  end
end
