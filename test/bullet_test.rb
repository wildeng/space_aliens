require_relative 'helper'

class BulletTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @bullet = Bullet.new(@window, 100, 200)
  end

  def test_initialization
    assert_equal 100, @bullet.x
    assert_equal 200, @bullet.y
    assert_equal 3, @bullet.radius
  end

  def test_update_moves_upward
    @bullet.update
    assert_equal 193, @bullet.y
  end

  def test_bounding_box
    box = @bullet.bounding_box
    assert_equal 100, box[:left]
    assert_equal 103, box[:right]
    assert_equal 200, box[:top]
    assert_equal 205, box[:bottom]
  end

  def test_off_screen_when_below_zero
    refute @bullet.off_screen?
    30.times { @bullet.update }
    assert @bullet.off_screen?
  end

  def test_on_screen_when_above_zero
    10.times { @bullet.update }
    refute @bullet.off_screen?
  end
end
