local play = {
  assets = {
    score = love.graphics.newFont(20),
    default = love.graphics.getFont(),
    spawn = love.audio.newSource("spawn.wav", "static"),
    died = love.audio.newSource("died.wav", "static"),
    ball = love.audio.newSource("ball.wav", "static")
  },
  balls = {},
  player = {
    x = 0,
    y = 0,
    width = 40,
    height = 40,
    speed = 300
  },
  difficulty = 2,
  sound = true,
  map_wall_width = 20,
  game_time_score = 0
}

function play:toggle_sound()
  self.sound = not self.sound 
  return self.sound 
end

function play:toggle_difficulty()
  self.difficulty = self.difficulty + 1
  if self.difficulty > 3 then
    self.difficulty = 1
  end
  return self.difficulty
end

function play:entered()
  local window_width, window_height = love.graphics.getDimensions()

  self.player.x = window_width / 2 - self.player.width / 2
  self.player.y = window_height / 2 - self.player.height / 2

  self.balls = {}

  self.game_time_score = 0
  if self.sound then
    self.assets.spawn:play()
  end
end

function play:update(dt)
  local window_width, window_height = love.graphics.getDimensions()

  -- Update game score timer
  self.game_time_score = self.game_time_score + dt

  -- Apply player movement
  if love.keyboard.isDown("a", "left") and self.player.x > self.map_wall_width then
    self.player.x = self.player.x - self.player.speed * dt
  end 
  if love.keyboard.isDown("w", "up") and self.player.y > self.map_wall_width then
    self.player.y = self.player.y - self.player.speed * dt
  end 
  if love.keyboard.isDown("s", "down") and self.player.y < window_height - self.map_wall_width - self.player.height then
    self.player.y = self.player.y + self.player.speed * dt
  end 
  if love.keyboard.isDown("d", "right") and self.player.x < window_width - self.map_wall_width - self.player.width then
    self.player.x = self.player.x + self.player.speed * dt
  end 

  -- Spawn more balls if the time permits
  while #self.balls < (self.game_time_score / 4) * self.difficulty do
    local ball = {
      size = love.math.random(30, 100),
      speed = love.math.random(50, 300),
      x = love.math.random(0, window_width),
      y = -50
    }
    table.insert(self.balls, ball)

    if self.sound then
      self.assets.ball:play()
    end
  end

  -- Apply ball movement
  for k, ball in pairs(self.balls) do
    ball.y = ball.y + ball.speed * dt
  end

  -- Remove balls that have left the map
  for i, ball in ipairs(self.balls) do
    if ball.y > window_height + ball.size then
      table.remove(self.balls, i)
    end
  end

  -- Check collisions
  for k, ball in pairs(self.balls) do
    local ball_distance_to_player = (((self.player.x + self.player.width / 2) - ball.x)^2+((self.player.y + self.player.height / 2) - ball.y)^2)^0.5
    if (ball_distance_to_player - self.player.width / 2) < ball.size then
      game.states.scoreboard:add_score(self.game_time_score)
      if self.sound then
        self.assets.died:play()
      end
      game:change_state("scoreboard")
    end
  end
end

function play:draw()
  local window_width, window_height = love.graphics.getDimensions()

  -- Draw map wall
  -- love.graphics.setColor(232, 213, 183) -- love version prior to 0.11.0
  love.graphics.setColor(232 / 255 ,213 / 255, 183 / 255) -- love version prior to 0.11.0
  love.graphics.rectangle("fill", 0, 0, window_width, window_height)

  -- Draw map play space
  -- love.graphics.setColor(14, 36, 48) -- love versions prior to 0.11.0
  love.graphics.setColor(14 / 255, 36 / 255, 48 / 255)
  love.graphics.rectangle("fill", self.map_wall_width, self.map_wall_width, 
    window_width - self.map_wall_width * 2, window_height - self.map_wall_width * 2)

  -- Draw player
  -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
  love.graphics.setColor(252 / 255, 58 / 255, 81 / 255)
  love.graphics.rectangle("fill", self.player.x, self.player.y, self.player.width, self.player.height) 

  -- Draw score timer
  -- love.graphics.setColor(232, 213, 183) -- love version prior to 0.11.0
  love.graphics.setColor(232 / 255 ,213 / 255, 183 / 255) -- love version prior to 0.11.0
  love.graphics.setFont(self.assets.score)
  love.graphics.print("Score: " .. self.game_time_score, 50, 50)
  love.graphics.setFont(self.assets.default)
  
  -- love.graphics.setColor(232, 213, 183) -- love version prior to 0.11.0
  love.graphics.setColor(232 / 255 ,213 / 255, 183 / 255) -- love version prior to 0.11.0
  for k, ball in pairs(self.balls) do
    love.graphics.circle("fill", ball.x, ball.y, ball.size)
  end
end

return play
