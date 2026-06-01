require_relative 'helper'

class SpaceshipTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @spaceship = Spaceship.new(@window)
  end

  def test_initialization
    expected_x = (@window.width - @spaceship.width) / 2
    assert_equal expected_x, @spaceship.x
    assert_equal @window.height - @spaceship.height - 10, @spaceship.y
    assert @spaceship.alive
  end

  def test_move_left
    initial_x = @spaceship.x
    @spaceship.move_left
    assert_equal initial_x - 5, @spaceship.x
  end

  def test_move_right
    initial_x = @spaceship.x
    @spaceship.move_right
    assert_equal initial_x + 5, @spaceship.x
  end

  def test_left_boundary
    @spaceship = Spaceship.new(MockWindow.new(100, 100))
    20.times { @spaceship.move_left }
    assert_equal 0, @spaceship.x
  end

  def test_right_boundary
    @spaceship = Spaceship.new(MockWindow.new(100, 100))
    20.times { @spaceship.move_right }
    assert_equal 100 - @spaceship.width, @spaceship.x
  end

  def test_fire_creates_bullet
    bullet = @spaceship.fire
    assert_instance_of Bullet, bullet
    assert_equal @spaceship.x + @spaceship.width / 2 - 2.5, bullet.x
    assert_equal @spaceship.y, bullet.y
  end

  def test_explode_sets_alive_false
    @spaceship.explode
    refute @spaceship.alive
  end

  def test_explode_only_once
    @spaceship.explode
    refute @spaceship.alive
    @spaceship.explode
    refute @spaceship.alive
  end

  def test_respawn_restores_alive
    @spaceship.explode
    @spaceship.respawn
    assert @spaceship.alive
  end

  def test_respawn_resets_position
    @spaceship.move_left
    @spaceship.move_left
    @spaceship.explode
    @spaceship.respawn

    expected_x = (@window.width - @spaceship.width) / 2
    assert_equal expected_x, @spaceship.x
  end

  def test_update_decrements_explosion_timer
    @spaceship.explode
    @spaceship.update
    assert @spaceship.alive == false
  end

  def test_bounding_box
    box = @spaceship.bounding_box
    assert_equal @spaceship.x, box[:left]
    assert_equal @spaceship.x + @spaceship.width, box[:right]
    assert_equal @spaceship.y, box[:top]
    assert_equal @spaceship.y + @spaceship.height, box[:bottom]
  end

  def test_bounding_box_follows_movement
    @spaceship.move_right
    box = @spaceship.bounding_box
    assert_equal @spaceship.x, box[:left]
  end

  def test_explosion_creates_particles
    @spaceship.explode
    particles = @spaceship.instance_variable_get(:@explosion_particles)
    assert_equal 20, particles.length
    particles.each do |p|
      assert_kind_of Numeric, p[:x]
      assert_kind_of Numeric, p[:y]
      assert_kind_of Numeric, p[:dx]
      assert_kind_of Numeric, p[:dy]
    end
  end
end
