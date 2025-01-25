# frozen_string_literal: true

class Spaceship
  attr_reader :x, :y, :width, :height, :alive

  def initialize(window)
    @window = window
    @width = 30
    @height = 20
    reset_position
    @speed = 5
    @color = Gosu::Color::GREEN
    @alive = true
    @explosion_particles = []
    @explosion_duration = 60 # number of frames the explosion lasts
    @explosion_timer = 0
    @respawn_delay = 120 # frames before respawning
    @respan_timer = 0
    @flashing = false
    @flash_duration = 180 # number of frames the ship flashes after respawning
    @flash_timer = 0
  end

  def reset_position
    @x = (@window.width - @width) / 2
    @y = @window.height - @height - 10
    @initial_x = @x
    @initial_y = @y
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

  def explode
    return unless @alive

    @alive = false
    @explosion_timer = @explosion_duration
    @respan_timer = @respawn_delay

    20.times do
      angle = rand(360) * Math::PI / 180
      speed = rand(2..6)
      @explosion_particles << {
        x: @x + @width / 2,
        y: @y + @height / 2,
        dx: Math.cos(angle) * speed,
        dy: Math.sin(angle) * speed,
        size: rand(2..5),
        color: Gosu::Color.new(255, rand(200..255), rand(100..200), 0) # Orange/red colours
      }
    end
  end

  def respawn
    reset_position
    @alive = true
    @flashing = true
    @flash_timer = @flash_duration
  end

  def update
    if @explosion_timer.positive?
      @explosion_timer -= 1
      update_explosion_particles
    elsif @respan_timer.positive?
      @respan_timer -= 1
      respawn if @respan_timer <= 0
    end

    return unless @flash_timer.positive?

    @flash_timer -= 1
    @flashing = false if @flash_timer <= 0
  end

  def update_explosion_particles
    @explosion_particles.each do |particle|
      particle[:x] += particle[:dx]
      particle[:y] += particle[:dy]
      particle[:dy] += 1 # gravity effect
    end
  end

  def draw
    if @alive
      # Draw the spaceship with flashing effect when recently respawned
      if !@flashing || (@flashing && @flash_timer % 10 >= 5)
        @window.draw_rect(@x, @y, @width, @height, @color)
        @window.draw_rect((@x + @width / 2) - 2.5, @y - 5, 5, 5, @color)
      end
    elsif @explosion_timer.positive?
      # Draw explosion particles
      @explosion_particles.each do |particle|
        @window.draw_rect(
          particle[:x],
          particle[:y],
          particle[:size],
          particle[:size],
          particle[:color]
        )
      end
    end
  end

  def bounding_box
    {
      left: 0,
      right: @window.width,
      top: @initial_y - 5,
      bottom: @window.height
    }
  end
end
