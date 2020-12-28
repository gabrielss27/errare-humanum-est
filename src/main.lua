local fun = require 'fun'

local wheels_fp = fun {0, 1, 2}:map(fun 'i -> "assets/wheel" .. i .. ".png"')

local wheels
local bg

local rot = fun {0, 0, 0}
local selected
local w, h
local sc = 1
local dx, dy, ds = 0, 0, 150
local ox, oy

local function rwrap(x)
  x = math.fmod(x, math.pi * 2)
  if x < 0 then
    x = x + math.pi * 2
  end
  return x
end

local function in_circle(ox, oy, r, x, y)
  local d = math.sqrt((x - ox) ^ 2 + (y - oy) ^ 2)
  return d <= r
end

local function select_wheel(x, y)
  selected = nil
  for i, wheel in ipairs(wheels) do
    local r = wheel:getHeight() * 0.5 * sc
    if in_circle(ox, oy, r, x, y) then
      selected = i
    end
  end
end

local function move_wheel(x, y, dx, dy)
  if not selected then
    return
  end
  local r0 = math.atan2(y - dy - oy, x - dx - ox)
  local rf = math.atan2(y - oy, x - ox)
  local dr = rf - r0
  rot[selected] = rwrap(rot[selected] + dr)
end

function love.load()
  w, h = love.graphics.getDimensions()
  bg = love.graphics.newImage('assets/bg.jpg')
  wheels = wheels_fp:map(fun 'fp -> love.graphics.newImage(fp)')
end

function love.update(dt)
  if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
    dy = dy + dt * ds
  end
  if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
    dy = dy - dt * ds
  end
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    dx = dx + dt * ds
  end
  if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
    dx = dx - dt * ds
  end
  ox, oy = w / 2 + dx, h / 2 + dy
end

local function draw_debug()
  love.graphics.setColor(1, 0, 0)
  for _, wheel in ipairs(wheels) do
    local r = wheel:getHeight() * 0.5 * sc
    love.graphics.circle('line', ox, oy, r)
    love.graphics.line(ox, oy, love.mouse.getPosition())
  end
  love.graphics.setColor(1, 1, 1)
end

function love.draw()
  local bgw, bgh = bg:getDimensions()
  love.graphics.draw(bg, ox, oy, 0, sc, sc, bgw / 2, bgh / 2)
  for i, wheel in ipairs(wheels) do
    local ww, wh = wheel:getDimensions()
    love.graphics.draw(wheel, ox, oy, rot[i], sc, sc, ww / 2, wh / 2)
  end
  -- draw_debug()
end

function love.keyreleased(key)
  if key == 'space' then
    dx, dy = 0, 0
  end
end

function love.wheelmoved(x, y)
  if y > 0 then
    sc = sc + 0.1
  elseif y < 0 and sc > 0.2 then
    sc = sc - 0.1
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    select_wheel(x, y)
  end
end

function love.mousemoved(x, y, dx, dy)
  move_wheel(x, y, dx, dy)
end

function love.mousereleased(x, y, button)
  selected = nil
end
