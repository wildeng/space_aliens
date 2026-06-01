# Space Aliens

A Space Invaders-style arcade game written in Ruby with the [Gosu](https://www.libgosu.org/) 2D gaming library.

All graphics are procedurally drawn with Gosu primitives — no external assets required.

## Prerequisites

- **Ruby 3.3.0**
- **Bundler** (`gem install bundler`)
- **SDL2** (Gosu dependency): `brew install sdl2`

## Setup

```bash
bundle install
```

## How to Play

```bash
ruby space_aliens.rb
```

| Key            | Action         |
|----------------|----------------|
| ← / →          | Move spaceship |
| Space          | Fire bullet    |
| R              | Restart game   |

You start with 3 lives. Destroy all 40 aliens to win.

## Running Tests

```bash
ruby -Ilib -Itest test/alien_test.rb
ruby -Ilib -Itest test/alien_swarm_test.rb
ruby -Ilib -Itest test/spaceship_test.rb
ruby -Ilib -Itest test/bullet_test.rb
ruby -Ilib -Itest test/score_manager_test.rb
```

Or run all at once:

```bash
for f in test/*_test.rb; do ruby -Ilib -Itest "$f"; done
```

## Project Structure

```
├── Gemfile              # Ruby dependencies
├── Gemfile.lock         # Locked dependency versions
├── space_aliens.rb      # Main entry point / game window
├── lib/
│   ├── alien.rb         # Individual alien (pixel art, damage states)
│   ├── alien_swarm.rb   # Alien formation, movement, difficulty scaling
│   ├── bullet.rb        # Player projectile
│   ├── score_manager.rb # Score, lives, collision detection, game state
│   └── spaceship.rb     # Player ship with explosion + respawn
└── test/
    ├── helper.rb        # MockWindow test helper
    ├── alien_test.rb
    ├── alien_swarm_test.rb
    ├── bullet_test.rb
    ├── score_manager_test.rb
    └── spaceship_test.rb
```

## Tech Stack

- **Ruby 3.3.0**
- **Gosu 1.4** — 2D game library (windowing, input, drawing)
- **Minitest 5** — unit testing
