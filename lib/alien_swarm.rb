# frozen_string_literal: true

# class that defines a swarn of aliens
class AlienSwarm
  attr_reader :aliens, :bottom

  def initialize(window)
    @window = window
    @aliens = []
    @move_timer = 0
    @move_interval = 30 # Frames between moves
    @drop_amount = 20
    @horizontal_step = 10
    @steps_before_drop = 10
    @current_step = 0
    @speed = 2
    @direction = :right
    @bottom = 300
    @last_row = 5
    create_swarm
  end

  def create_swarm
    colors = %i[red blue green yellow cyan]
    5.times do |row|
      color = colors[row]
      8.times do |col|
        @aliens << Alien.new(@window, 100 + col * 60, 50 + row * 50, color, row)
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
    @aliens.each do |alien|
      if @direction == :right
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
    @direction = @direction == :right ? :left : :right

    @aliens.each do |alien|
      alien.drop(@drop_amount)
    end
    # we need this to check if the last line collides with the spaceship
    @bottom += @drop_amount - removed_row_check_adjust
  end

  def removed_row_check_adjust
    return 0 if @last_row.negative?

    aliens_by_row = @aliens.group_by(&:row)
    if aliens_by_row[@last_row].nil? || aliens_by_row[@last_row].empty?
      @last_row -= 1
      return 50
    end
    0
  end

  def remove_dead_aliens
    @aliens.reject!(&:dead?)
  end

  def all_destroyed?
    @aliens.empty?
  end
end
