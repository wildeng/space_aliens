# frozen_string_literal: true

require_relative 'helper'

class AlienSwarmTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @swarm = AlienSwarm.new(@window)
  end

  def test_swarm_creation
    assert_equal 40, @swarm.aliens.count # 5 rows * 8 columns
  end
end
