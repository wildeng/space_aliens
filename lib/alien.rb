# frozen_string_literal: true

# Class that defines how an alien looks
class Alien
  attr_accessor :x, :y, :direction

  def initialize(window, horiz, vert, color)
    @x = horiz
    @y = vert
    @window = window
    @color = get_color(color)
    @direction = :right
    @size = 5
    @health = 3
  end

  def bounding_box
    {
      left: @x,
      right: @x + 9 * @size,
      top: @y,
      bottom: @y + 8 * @size
    }
  end

  def hit!
    @health -= 1
    adjust_size
  end

  def dead?
    @health <= 0
  end

  def move(speed)
    @x += speed * (direction == :right ? +1 : -1)
  end

  def drop(amount)
    @y += amount
  end

  def draw
    case @health
    when 3
      draw_undamaged
    when 2
      draw_slightly_damaged
    when 1
      draw_heavily_damaged
    end
  end

  def draw_undamaged
    draw_rect(3, 2)
    draw_rect(6, 2)
    (2..7).each { |i| draw_rect(i, 3) }
    (1..8).each { |i| draw_rect(i, 4) }
    draw_rect(2, 5)
    draw_rect(4, 5)
    draw_rect(5, 5)
    draw_rect(7, 5)
    draw_rect(2, 6)
    draw_rect(7, 6)
    draw_rect(3, 7)
    draw_rect(6, 7)
  end

  def draw_slightly_damaged
    draw_rect(3, 2)
    draw_rect(6, 2)
    (2..7).each { |i| draw_rect(i, 3) }
    (1..8).each { |i| draw_rect(i, 4) }
    draw_rect(2, 5)
    draw_rect(7, 5)
    draw_rect(2, 6)
    draw_rect(7, 6)
    draw_rect(3, 7)
    draw_rect(6, 7)
  end

  def draw_heavily_damaged
    draw_rect(3, 2)
    draw_rect(6, 2)
    (2..7).each { |i| draw_rect(i, 3) }
    (1..8).each { |i| draw_rect(i, 4) }
    draw_rect(2, 5)
    draw_rect(7, 5)
  end

  def draw_rect(horiz, vert)
    @window.draw_rect(@x + horiz * @size, @y + vert * @size, @size, @size, @color)
  end

  def get_color(color_name)
    {
      red: Gosu::Color::RED,
      green: Gosu::Color::GREEN,
      yellow: Gosu::Color::YELLOW,
      cyan: Gosu::Color::CYAN,
      blue: Gosu::Color::BLUE
    }[color_name] || Gosu::Color::GREEN
  end

  def adjust_size
    @size = 5 - (3 - @health)
  end
end
