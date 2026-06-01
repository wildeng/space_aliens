require_relative 'helper'

class ScoreManagerTest < Minitest::Test
  def setup
    @manager = ScoreManager.new
  end

  def test_initialization
    assert_equal 0, @manager.score
    assert_equal 3, @manager.lives
    refute @manager.game_over?
    refute @manager.life_lost?
    refute @manager.won?
  end

  def test_increment
    @manager.increment(10)
    assert_equal 10, @manager.score
  end

  def test_increment_default
    @manager.increment
    assert_equal 1, @manager.score
  end

  def test_decrement_lives
    @manager.decrement_lives
    assert_equal 2, @manager.lives
    assert @manager.life_lost?
    refute @manager.game_over?
  end

  def test_game_over_after_all_lives_lost
    @manager.decrement_lives
    refute @manager.game_over?
    @manager.decrement_lives
    refute @manager.game_over?
    @manager.decrement_lives
    assert @manager.game_over?
    assert_equal 0, @manager.lives
  end

  def test_collision_overlapping_boxes
    box_a = Struct.new(:bounding_box).new({ left: 0, right: 10, top: 0, bottom: 10 })
    box_b = Struct.new(:bounding_box).new({ left: 5, right: 15, top: 5, bottom: 15 })
    assert @manager.collision?(box_a, box_b)
  end

  def test_collision_non_overlapping_boxes
    box_a = Struct.new(:bounding_box).new({ left: 0, right: 10, top: 0, bottom: 10 })
    box_b = Struct.new(:bounding_box).new({ left: 20, right: 30, top: 20, bottom: 30 })
    refute @manager.collision?(box_a, box_b)
  end

  def test_collision_with_nil
    box = Struct.new(:bounding_box).new({ left: 0, right: 10, top: 0, bottom: 10 })
    refute @manager.collision?(nil, box)
    refute @manager.collision?(box, nil)
  end

  def test_collision_touching_edges
    box_a = Struct.new(:bounding_box).new({ left: 0, right: 10, top: 0, bottom: 10 })
    box_b = Struct.new(:bounding_box).new({ left: 11, right: 20, top: 11, bottom: 20 })
    refute @manager.collision?(box_a, box_b)
  end

  def test_life_lost_reset
    @manager.decrement_lives
    assert @manager.life_lost?
    @manager.life_lost_reset
    refute @manager.life_lost?
  end

  def test_reset
    @manager.increment(50)
    @manager.decrement_lives
    @manager.decrement_lives
    @manager.decrement_lives
    assert @manager.game_over?

    @manager.reset
    assert_equal 0, @manager.score
    assert_equal 3, @manager.lives
    refute @manager.game_over?
    refute @manager.life_lost?
  end

  def test_no_increment_after_game_over
    @manager.decrement_lives
    @manager.decrement_lives
    @manager.decrement_lives
    @manager.increment(100)
    assert_equal 0, @manager.score
  end

  def test_win_state
    refute @manager.won?
    @manager.win
    assert @manager.won?
  end

  def test_reset_clears_win
    @manager.win
    @manager.reset
    refute @manager.won?
  end
end
