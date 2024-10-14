# frozen_string_literal: true

# class that defines a swarn of aliens
class AlienSwarm
  attr_reader :aliens

  def initialize(window)
    @window = window
    @aliens = []
    @move_timer = 0
    @move_interval = 30 # Frames between moves
    @drop_amount = 20
    @horizontal_step = 10
    @steps_before_drop = 4
    @current_step = 0
    @speed = 2
    create_swarm
  end

  def create_swarm
    colors = %i[red blue green yellow cyan]
    5.times do |row|
      color = colors[row]
      8.times do |col|
        @aliens << Alien.new(@window, 100 + col * 60, 50 + row * 50, color)
      end
    end
  end

  def draw
    @aliens.each(&:draw)
  end

  def update
    @move_timer += 1
    return unless @move_timer > @move_interval

    move_aliens
    @move_timer = 0
  end

  def move_aliens
    direction = @aliens.first.direction
    @aliens.each do |alien|
      if direction == :right
        alien.x += @horizontal_step
      else
        alien.x -= @horizontal_step
      end
    end

    @current_step += 1

    if @current_step >= @steps_before_drop
      change_direction_and_drop
      @current_step = 0
    end
    # Increase speed as aliens are destroyed
    @move_interval = [5, 30 - (@aliens.size / 5)].max
  end

  def change_direction_and_drop
    new_direction = @aliens.first.direction == :right ? :left : :right

    @aliens.each do |alien|
      alien.direction = new_direction
      alien.drop(@drop_amount)
    end
  end

  def remove_dead_aliens
    @aliens.reject!(&:dead?)
  end
end
