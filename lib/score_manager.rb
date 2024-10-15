# frozen_string_literal: true

class ScoreManager
  attr_reader :score

  def initialize
    @score = 0
  end

  def increment(points = 1)
    @score += points
  end

  def draw(window)
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

  def collision?(alien, bullet)
    alien_box = alien.bounding_box
    bullet_box = bullet.bounding_box

    !(alien_box[:left] > bullet_box[:left] ||
      alien_box[:right] < bullet_box[:left] ||
      alien_box[:top] > bullet_box[:bottom] ||
      alien_box[:bottom] < bullet_box[:top])
  end
end
