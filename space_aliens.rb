require 'gosu'
require_relative 'lib/alien'
require_relative 'lib/alien_swarm'
require_relative 'lib/spaceship'
require_relative 'lib/bullet'
require_relative 'lib/score_manager'

class GameWindow < Gosu::Window
  def initialize
    super 800, 600
    self.caption = '80s style game create in collaboration with Claude Ai'
    @alien_swarm = AlienSwarm.new(self)
    @spaceship = Spaceship.new(self)
    @score_manager = ScoreManager.new
    @bullets = []
  end

  def update
    return if @score_manager.game_over?
    return if @score_manager.life_lost?

    @alien_swarm.remove_dead_aliens
    @alien_swarm.update
    @spaceship.update
    @spaceship.move_left if Gosu.button_down?(Gosu::KB_LEFT)
    @spaceship.move_right if Gosu.button_down?(Gosu::KB_RIGHT)

    @bullets << @spaceship.fire if Gosu.button_down?(Gosu::KB_SPACE) && @bullets.empty?

    @bullets.each(&:update)
    @bullets.reject!(&:off_screen?)

    @bullets.each do |bullet|
      @alien_swarm.aliens.each do |alien|
        handle_collision(alien, bullet) if @score_manager.collision?(alien, bullet) && !alien.dead?
      end
    end

    return unless @spaceship.alive

    @alien_swarm.aliens.each do |alien|
      if !alien.dead? && @score_manager.collision?(alien, @spaceship)
        handle_spaceship_collision(alien)
        break
      end
    end
  end

  def handle_collision(alien, bullet)
    alien.hit!
    @bullets.delete(bullet)
    @score_manager.increment(10)
    @score_manager.increment(50) if alien.dead?
  end

  def handle_spaceship_collision(alien)
    alien.damage = 2
    @score_manager.decrement_lives
    @spaceship.explode
  end

  def button_down(id)
    if @score_manager.life_lost? && !@score_manager.game_over?
      @score_manager.life_lost_reset
      @alien_swarm = AlienSwarm.new(self)
      @spaceship = Spaceship.new(self)
      @bullets.clear
      return
    end
    return unless id == Gosu::KB_R && @score_manager.game_over?

    @score_manager.reset
    @alien_swarm = AlienSwarm.new(self)
    @spaceship = Spaceship.new(self)
    @bullets.clear
  end

  def draw
    @alien_swarm.draw
    @spaceship.draw
    @bullets.each(&:draw)
    @score_manager.draw(self)
  end
end

GameWindow.new.show
