# frozen_string_literal: true

class ScoreManager
  attr_reader :score, :lives

  def initialize
    @score = 0
    @lives = 3
    @life_lost = false
    @game_over = false
    @won = false
    @font_small = nil
    @font_large = nil
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
    draw_win(window) if @won
    draw_life_lost_prompt(window) if @life_lost
  end

  def font_small(window)
    @font_small ||= Gosu::Font.new(window, Gosu.default_font_name, 20)
  end

  def font_large(window)
    @font_large ||= Gosu::Font.new(window, Gosu.default_font_name, 50)
  end

  def draw_score(window)
    font_small(window).draw_text(
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
    font_small(window).draw_text(
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
    text = 'GAME OVER'
    x = (window.width - font_large(window).text_width(text)) / 2
    y = window.height / 2
    font_large(window).draw_text(text, x, y, 1, 1.0, 1.0, Gosu::Color::RED)
    draw_restart_prompt(window, y + 60)
  end

  def draw_win(window)
    text = 'YOU WIN!'
    x = (window.width - font_large(window).text_width(text)) / 2
    y = window.height / 2
    font_large(window).draw_text(text, x, y, 1, 1.0, 1.0, Gosu::Color::GREEN)
    draw_restart_prompt(window, y + 60)
  end

  def draw_restart_prompt(window, y)
    text = 'Press R to restart'
    x = (window.width - font_small(window).text_width(text)) / 2
    font_small(window).draw_text(text, x, y, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def draw_life_lost_prompt(window)
    text = 'Press any key to continue'
    x = (window.width - font_small(window).text_width(text)) / 2
    y = window.height / 2
    font_small(window).draw_text(text, x, y, 1, 1.0, 1.0, Gosu::Color::WHITE)
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

  def won?
    @won
  end

  def win
    @won = true
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
    @life_lost = false
    @won = false
  end
end
