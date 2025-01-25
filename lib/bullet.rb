# frozen_string_literal: true

# class for the bullet
class Bullet
  attr_reader :x, :y, :radius

  def initialize(window, coord_x, coord_y)
    @window = window
    @x = coord_x
    @y = coord_y
    @speed = 7
    @radius = 3
    @color = Gosu::Color::WHITE
  end

  def bounding_box
    {
      left: @x,
      right: @x + 3,
      top: @y,
      bottom: @y + 5
    }
  end

  def update
    @y -= @speed
  end

  def draw
    @window.draw_rect(@x, @y, 3, 5, @color)
  end

  def off_screen?
    bounding_box[:bottom].negative?
  end
end
