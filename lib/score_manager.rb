# frozen_string_literal: true

class ScoreManager
  attr_reader :score, :lives

  def initialize
    @score = 0
    @lives = 3
    @life_lost = false
    @game_over = false
  end

  def increment(points = 1)
    @score += points unless @game_over
  end

  def decrement_lives
    @lives -= 1
    @life_lost = true
    @game_over = true if @lives < 1
  end

  def draw(window)
    draw_score(window)
    draw_lives(window)
    draw_game_over(window) if @game_over
  end

  def draw_score(window)
    Gosu::Font.new(
      window,
      Gosu.default_font_name,
      20
    ).draw_text(
      "Score: #{@score}",
      10,
      10,
      1,
      1.0,
      1.0,
      Gosu::Color::WHITE
    )
  end

  def draw_lives(window)
    Gosu::Font.new(
      window,
      Gosu.default_font_name,
      20
    ).draw_text(
      "Lives: #{@lives}",
      10,
      40,
      1,
      1.0,
      1.0,
      Gosu::Color::WHITE
    )
  end

  def draw_game_over(window)
    font = Gosu::Font.new(window, Gosu.default_font_name, 50)
    text = 'GAME OVER'
    x = (window.width - font.text_width(text)) / 2
    y = window.height / 2
    font.draw_text(text, x, y, 1, 1.0, 1.0, Gosu::Color::RED)
  end

  def collision?(object_one, object_two)
    return false if object_one.nil? || object_two.nil?

    object_one_box = object_one.bounding_box
    object_two_box = object_two.bounding_box

    !(object_one_box[:right] < object_two_box[:left] ||
      object_one_box[:left] > object_two_box[:right] ||
      object_one_box[:bottom] < object_two_box[:top] ||
      object_one_box[:top] > object_two_box[:bottom])
  end

  def game_over?
    @game_over
  end

  def life_lost?
    @life_lost
  end

  def life_lost_reset
    @life_lost = false
  end

  def reset
    @score = 0
    @lives = 3
    @game_over = false
  end
end
