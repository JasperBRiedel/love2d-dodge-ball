local menu = {
  assets = {
    title = love.graphics.newFont(30),
    menu = love.graphics.newFont(20),
    default = love.graphics.getFont()
  },
  items = {
    "New Game",
    "Scoreboard",
    "Settings",
    "Quit"
  },
  selected_item = 1
}

function menu:entered()
  -- Reset menu to first item when state entered
  self.selected_item = 1
end

function menu:draw()
  -- Calculate drawable positions
  local window_width, window_height = love.graphics.getDimensions()
  local window_width_center, window_height_center = window_width / 2, window_height / 2

  local menu_width, menu_height = 400, 300
  local menu_width_center, menu_height_center = menu_width / 2, menu_height / 2

  local menu_x, menu_y = window_width_center - menu_width_center, window_height_center - menu_height_center

  -- Set window background
  -- love.graphics.setBackgroundColor(14, 36, 48) -- love versions prior to 0.11.0
  love.graphics.setBackgroundColor(14 / 255, 36 / 255, 48 / 255)

  -- Draw background rectangle
  -- love.graphics.setColor(232, 213, 183) -- love version prior to 0.11.0
  love.graphics.setColor(232 / 255 ,213 / 255, 183 / 255) -- love version prior to 0.11.0
  love.graphics.rectangle("fill", menu_x, menu_y, menu_width, menu_height)

  -- Draw title text
  -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
  love.graphics.setColor(252 / 255, 58 / 255, 81 / 255)
  love.graphics.setFont(self.assets.title)
  love.graphics.print("Dodge ball", menu_x + 40, menu_y + 20)
  love.graphics.setFont(self.assets.default)

  -- Draw help text
  love.graphics.print("Movement: [A] [W] [S] [D] Select: [SPACE]", menu_x + 40, menu_y + menu_height - 30)


  -- Draw menu text
  love.graphics.setFont(self.assets.menu)
  for i, item in ipairs(self.items) do
    local item_x, item_y = menu_x + 40, menu_y + 50 + 30 * i

    if i == self.selected_item then
      -- love.graphics.setColor(14, 36, 48) -- love versions prior to 0.11.0
      love.graphics.setColor(14 / 255, 36 / 255, 48 / 255)
    else
      -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
      love.graphics.setColor(252 / 255, 58 / 255, 81 / 255)
    end
    love.graphics.print(item, item_x, item_y)
  end
  love.graphics.setFont(self.assets.default)

end

function menu:keypressed(key)
  if key == "w" or key == "up" then
    self.selected_item = self.selected_item - 1

    if self.selected_item < 1 then
      self.selected_item = #self.items
    end
  end

  if key == "s" or key == "down" then
    self.selected_item = self.selected_item + 1

    if self.selected_item > #self.items then
      self.selected_item = 1
    end
  end

  if key == "space" or key == "return" then
    if self.selected_item == 1 then
      game:change_state("play")
    elseif self.selected_item == 2 then
      game:change_state("scoreboard")
    elseif self.selected_item == 3 then
      game:change_state("settings")
    elseif self.selected_item == 4 then
      love.event.quit(0)
    end
  end
end

return menu
