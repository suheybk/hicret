--[[
  LÖVE 2D Yapılandırma
  love.conf() başlamadan önce çalışır.
--]]

function love.conf(t)
  t.identity    = "hicret"      -- Kayıt klasörü adı
  t.version     = "11.4"
  t.console     = false

  t.window.title        = "Hicret"
  t.window.width        = 800
  t.window.height       = 600
  t.window.resizable    = true
  t.window.minwidth     = 320
  t.window.minheight    = 240
  t.window.msaa         = 0
  t.window.highdpi      = false

  -- Kullanılmayan modülleri kapat (performans)
  t.modules.joystick  = false
  t.modules.physics   = false
  t.modules.video     = false

  -- love.js (Emscripten) OpenAL uyumsuzluğu: ses modülleri web'de
  -- WASM "memory access out of bounds" hatası veriyor.
  -- Bkz: https://github.com/Davidobot/love.js/issues/106
  t.modules.audio = false
  t.modules.sound = false
end
