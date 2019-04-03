local settings = {
  assets = {
    title = love.graphics.newFont(30),
    menu = love.graphics.newFont(20),
    default = love.graphics.getFont()
  },
  selected_item = 1,
  settings = {
    "Sound [on]",
    "Difficulty [normal]",
    "Clear scoreboard",
    "Return to menu"
  }
}


function settings:draw()
  -- Calculate drawable positions
  local window_width, window_height = love.graphics.getDimensions()
  local window_width_center, window_height_center = window_width / 2, window_height / 2

  local settings_width, settings_height = 400, 300
  local settings_width_center, settings_height_center = settings_width / 2, settings_height / 2

  local settings_x, settings_y = window_width_center - settings_width_center, window_height_center - settings_height_center

  -- Set window background
  -- love.graphics.setBackgroundColor(14, 36, 48) -- love versions prior to 0.11.0
  love.graphics.setBackgroundColor(14 / 255, 36 / 255, 48 / 255)

  -- Draw background rectangle
  -- love.graphics.setColor(232, 213, 183) -- love version prior to 0.11.0
  love.graphics.setColor(232 / 255 ,213 / 255, 183 / 255) -- love version prior to 0.11.0
  love.graphics.rectangle("fill", settings_x, settings_y, settings_width, settings_height)

  -- Draw title text
  -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
  love.graphics.setColor(252 / 255, 58 / 255, 81 / 255)
  love.graphics.setFont(self.assets.title)
  love.graphics.print("Settings", settings_x + 40, settings_y + 20)
  love.graphics.setFont(self.assets.default)

  -- Draw help text
  love.graphics.print("Move: [W] [S] Select: [SPACE]", settings_x + 40, settings_y + settings_height - 30)

  -- Draw menu text
  love.graphics.setFont(self.assets.menu)
  for i, setting in ipairs(self.settings) do
    local setting_x, setting_y = settings_x + 40, settings_y + 50

    if i == self.selected_item then
      -- love.graphics.setColor(14, 36, 48) -- love versions prior to 0.11.0
      love.graphics.setColor(14 / 255, 36 / 255, 48 / 255)
    else
      -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
      love.graphics.setColor(252 / 255, 58 / 255, 81 / 255)
    end

    love.graphics.print(setting, setting_x, 30 * i + setting_y)
  end
  love.graphics.setFont(self.assets.default)

end

function settings:keypressed(key)
  if key == "w" or key == "up" then
    self.selected_item = self.selected_item - 1

    if self.selected_item < 1 then
      self.selected_item = #self.settings
    end
  end

  if key == "s" or key == "down" then
    self.selected_item = self.selected_item + 1

    if self.selected_item > #self.settings then
      self.selected_item = 1
    end
  end

  if key == "return" or key == "space" then
    if self.selected_item == 1 then
      if game.states.play:toggle_sound() then
        self.settings[1] = "Sound [on]"
      else 
        self.settings[1] = "Sound [off]"
      end
    elseif self.selected_item == 2 then
      local difficulty = game.states.play:toggle_difficulty()

      if difficulty == 1 then
        self.settings[2] = "Difficulty [easy]"
      elseif difficulty == 2 then
        self.settings[2] = "Difficulty [normal]"
      elseif difficulty == 3 then
        self.settings[2] = "Difficulty [hard]"
      end
    elseif self.selected_item == 3 then
      game.states.scoreboard:clear_scores()
    elseif self.selected_item == 4 then
      game:change_state("menu")
    end
  end
end

return settings
