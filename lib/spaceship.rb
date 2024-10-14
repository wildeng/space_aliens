# frozen_string_literal: true

class Spaceship
  attr_reader :x, :y, :width, :height

  def initialize(window)
    @window = window
    @width = 30
    @height = 20
    @x = (@window.width - @width) / 2
    @y = @window.height - @height - 10
    @speed = 5
    @color = Gosu::Color::GREEN
  end

  def fire
    Bullet.new(@window, (@x + @width / 2) - 2.5, @y)
  end

  def move_left
    @x = [@x - @speed, 0].max
  end

  def move_right
    @x = [@x + @speed, @window.width - @width].min
  end

  def draw
    @window.draw_rect(@x, @y, @width, @height, @color)
    @window.draw_rect((@x + @width / 2) - 2.5, @y - 5, 5, 5, @color)
  end
end
