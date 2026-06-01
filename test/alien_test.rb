require_relative 'helper'

class AlienTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @alien = Alien.new(@window, 100, 100, :green, 0)
  end

  def test_initialization
    assert_equal 100, @alien.x
    assert_equal 100, @alien.y
    assert_equal :right, @alien.direction
    assert_equal 0, @alien.damage
    assert_equal 0, @alien.row
  end

  def test_move_right
    @alien.move(5)
    assert_equal 105, @alien.x
    assert_equal 100, @alien.y
  end

  def test_move_left
    @alien.direction = :left
    @alien.move(5)
    assert_equal 95, @alien.x
  end

  def test_drop
    @alien.drop(20)
    assert_equal 120, @alien.y
  end

  def test_hit_increments_damage
    @alien.hit!
    assert_equal 1, @alien.damage
  end

  def test_hit_caps_at_two
    @alien.hit!
    @alien.hit!
    assert_equal 2, @alien.damage
    @alien.hit!
    assert_equal 2, @alien.damage
  end

  def test_not_dead_initially
    refute @alien.dead?
  end

  def test_dead_after_two_hits
    @alien.hit!
    refute @alien.dead?
    @alien.hit!
    assert @alien.dead?
  end

  def test_bounding_box
    box = @alien.bounding_box
    assert_equal 100, box[:left]
    assert_equal 145, box[:right]
    assert_equal 100, box[:top]
    assert_equal 140, box[:bottom]
  end

  def test_bounding_box_changes_with_position
    @alien.move(10)
    box = @alien.bounding_box
    assert_equal 110, box[:left]
  end

  def test_color_mapping
    alien_red = Alien.new(@window, 0, 0, :red, 1)
    assert_silent { alien_red.draw }

    alien_cyan = Alien.new(@window, 0, 0, :cyan, 1)
    assert_silent { alien_cyan.draw }
  end

  def test_default_color
    alien_invalid = Alien.new(@window, 0, 0, :unknown, 1)
    assert_silent { alien_invalid.draw }
  end

  def test_draw_state_changes_with_damage
    assert_silent { @alien.draw }
    @alien.hit!
    assert_silent { @alien.draw }
    @alien.hit!
    assert_silent { @alien.draw }
  end
end
