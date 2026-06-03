# frozen_string_literal: true

require_relative 'helper'

class GameWindowTest < Minitest::Test
  def setup
    @window = MockWindow.new
    @game_window = GameWindow.new
    @game_window.instance_variable_set(:@window, @window)
    @game_window.instance_variable_set(:@bullets, [])
    @game_window.instance_variable_set(:@spaceship, Spaceship.new(@window))
    @game_window.instance_variable_set(:@score_manager, ScoreManager.new)
    @game_window.instance_variable_set(:@alien_swarm, AlienSwarm.new(@window))
  end

  def test_debounce_bullet_firing
    # Mock Gosu.button_down? to simulate space key press
    def Gosu.button_down?(id)
      id == Gosu::KB_SPACE
    end

    # First press should fire a bullet
    @game_window.update
    assert_equal 1, @game_window.instance_variable_get(:@bullets).size
    assert_equal 15, @game_window.instance_variable_get(:@fire_cooldown)

    # Subsequent presses during cooldown should not fire
    14.times do
      @game_window.update
      assert_equal 1, @game_window.instance_variable_get(:@bullets).size
      assert @game_window.instance_variable_get(:@fire_cooldown).positive?
    end

    # After cooldown, another bullet can be fired
    @game_window.update
    assert_equal 0, @game_window.instance_variable_get(:@fire_cooldown)
  end
end