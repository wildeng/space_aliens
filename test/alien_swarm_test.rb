require_relative 'helper'

class AlienSwarmTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @swarm = AlienSwarm.new(@window)
  end

  def test_swarm_creation_count
    assert_equal 40, @swarm.aliens.count
  end

  def test_swarm_creation_rows_and_columns
    rows = @swarm.aliens.map(&:row).uniq.sort
    assert_equal [0, 1, 2, 3, 4], rows

    row0 = @swarm.aliens.select { |a| a.row == 0 }
    assert_equal 8, row0.count
  end

  def test_all_aliens_start_alive
    assert @swarm.aliens.none?(&:dead?)
  end

  def test_remove_dead_aliens
    @swarm.aliens[0].hit!
    @swarm.aliens[0].hit!
    @swarm.aliens[1].hit!
    @swarm.aliens[1].hit!

    @swarm.remove_dead_aliens
    assert_equal 38, @swarm.aliens.count
  end

  def test_all_destroyed_false_initially
    refute @swarm.all_destroyed?
  end

  def test_all_destroyed_true_when_empty
    @swarm.aliens.each do |alien|
      2.times { alien.hit! }
    end
    @swarm.remove_dead_aliens
    assert @swarm.all_destroyed?
  end

  def test_move_aliens_right
    initial_x = @swarm.aliens.map(&:x)
    @swarm.move_aliens
    @swarm.aliens.each_with_index do |alien, i|
      assert_equal initial_x[i] + 10, alien.x
    end
  end

  def test_change_direction_and_drop
    y_before = @swarm.aliens.first.y
    @swarm.change_direction_and_drop
    assert_equal y_before + 20, @swarm.aliens.first.y
    assert_equal :left, @swarm.instance_variable_get(:@direction)

    @swarm.move_aliens
    x_after = @swarm.aliens.first.x
    assert_operator x_after, :<, 100
  end

  def test_update_triggers_move_after_interval
    first_x = @swarm.aliens.first.x

    @swarm.update
    assert_equal first_x, @swarm.aliens.first.x

    30.times { @swarm.update }
    refute_equal first_x, @swarm.aliens.first.x
  end

  def test_speed_increases_as_aliens_are_destroyed
    20.times do |i|
      2.times { @swarm.aliens[i].hit! }
    end
    @swarm.remove_dead_aliens
    @swarm.move_aliens

    interval = @swarm.instance_variable_get(:@move_interval)
    assert_operator interval, :<, 30
  end

  def test_bottom_changes_on_drop
    initial_bottom = @swarm.bottom
    @swarm.change_direction_and_drop
    refute_equal initial_bottom, @swarm.bottom
  end
end
