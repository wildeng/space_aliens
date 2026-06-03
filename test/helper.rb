require 'minitest/autorun'
require 'gosu'
require_relative '../space_aliens'
require_relative '../lib/alien'
require_relative '../lib/alien_swarm'
require_relative '../lib/spaceship'
require_relative '../lib/bullet'
require_relative '../lib/score_manager'

class MockWindow
  attr_reader :width, :height

  def initialize(width = 800, height = 600)
    @width = width
    @height = height
  end

  def draw_rect(*args); end
end
