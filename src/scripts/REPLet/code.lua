REPLet = REPLet or {}
REPLet.config = REPLet.config or {
  fontSize = 12,
  font = "Ubuntu Mono",
  autoWrap = true,
  fgColor = "lime_green",
  color = "black",
  cmdColor = "cyan",
  borderColor = "lime_green",
  borderThickness = 1,
  addEchos = true,
}

local savefile = getMudletHomeDir() .. "/REPletConfig.lua"
REPLet.prompt = "\nREPLet:> "
REPLet.intro = [[
   __   __ ___  __      _
  /__\ /__/ _ \/ /  ___| |_
 / \///_\/ /_)/ /  / _ | __|
/ _  //_/ ___/ /__|  __| |_
\/ \_\__\/   \____/\___|\__|
       _   ___
__   _/ | / _ \
\ \ / | || | | |
 \ V /| || |_| |
  \_/ |_(_\___/
]]

function REPLet.save()
  table.save(savefile, REPLet.config)
end

function REPLet.load()
  if io.exists(savefile)then
    local cfg = {}
    table.load(savefile, cfg)
    REPLet.config = table.update(REPLet.config, cfg)
  end
end
local orecho, orcecho, ordecho, orhecho, ordisplay = recho, rcecho, rdecho, rhecho, rdisplay

function REPLet.addEchos()
  if not REPLet.config.addEchos then return end
  function recho(msg)
    if not msg:ends("\n") then
      msg = msg .. "\n"
    end
    REPLet.console:echo(msg)
  end

  function rcecho(msg)
    if not msg:ends("\n") then
      msg = msg .. "\n"
    end
    REPLet.console:cecho(msg)
    REPLet.console:setFgColor(REPLet.config.fgColor)
  end

  function rdecho(msg)
    if not msg:ends("\n") then
      msg = msg .. "\n"
    end
    REPLet.console:decho(msg)
    REPLet.console:setFgColor(REPLet.config.fgColor)
  end

  function rhecho(msg)
    if not msg:ends("\n") then
      msg = msg .. "\n"
    end
    REPLet.console:hecho(msg)
    REPLet.console:setFgColor(REPLet.config.fgColor)
  end

  function rdisplay(...)
    REPLet.console:display(...)
  end
end

function REPLet.removeEchos()
  if not REPLet.config.addEchos then return end
  recho, rcecho, rdecho, rhecho, rdisplay = orecho, orcecho, ordecho, orhecho, ordisplay
end

function REPLet.error(...)
  REPLet.console:setFgColor("red")
  for _,msg in pairs({...}) do
    REPLet.console:echo(f"ERROR:\n  {msg}\n")
  end
  REPLet.console:setFgColor(REPLet.config.fgColor)
end

function REPLet.usage()
  local console = REPLet.console
  local function echo(msg)
    console:echo(msg .. "\n")
  end
  echo("REPLet functions mostly like the 'lua' alias which ships with Mudlet")
  echo("REPLet runs in its own window, and will run arbitrary code you type in its command line")
  echo("REPLet comes with a few built in commands you can run inside the REPLet console only")
  echo("* clear")
  echo("  * clears the window and prints the intro")
  echo("* config")
  echo("  * prints the current REPLet configuration to the REPLet console.")
  echo("* exit")
  echo("  * closes the REPLet window")
  echo("* font <font name>")
  echo("  * sets the font for the REPLet console. example:")
  echo("  * font Ubuntu Mono")
  echo("* fontSize <font size>")
  echo("  * sets the fontSize for the REPLet console. example:")
  echo("  * fontSize 12")
  echo("* save")
  echo("  * saves the REPLet config")
  echo("* load")
  echo("  * loads the REPLet config")
  echo("* color <color name>")
  echo("  * sets the background color for the REPLet console. example:")
  echo("  * color black")
  echo("* cmdColor <color name>")
  echo("  * sets the color your entered commands are echoed to the REPLet console in. example:")
  echo("  * cmdColor cyan")
  echo("* fgColor <color name>")
  echo("  * sets the text color for the output in the REPLet console. example:")
  echo("  * fgColor lime_green")
  echo("* borderColor <color name>")
  echo("  * sets the color for the border around the input line. example:")
  echo("  * borderColor lime_green")
  echo("* borderThickness <number>")
  echo("  * thickness of the border around the input line, in pixels. example:")
  echo("  * borderThickness 1")
  echo("* autoWrap <true or false>")
  echo("  * turns on or off autoWrap. example:")
  echo("  * autoWrap true")
  echo("* addEchos <true or false>")
  echo("  * if true, adds recho, rcecho, rdecho, rhecho, and rdisplay functions to echo to the REPLet console.")
  echo("  * Only available in the console. example:")
  echo("  * addEchos true")
  echo("* usage")
  echo("  * prints this message")
  echo(REPLet.prompt)
end

function REPLet.styleCmdline()
  local borderThickness = REPLet.config.borderThickness
  local borderColor = Geyser.Color.hex(REPLet.config.borderColor)
  local fontSize = REPLet.config.fontSize
  local font = REPLet.config.font
  local bgColor = REPLet.config.color
  local cmdColor = Geyser.Color.hex(REPLet.config.cmdColor)
  local style = f[[
    border: {borderThickness}px solid {borderColor};
    font: {fontSize}pt "{font}";
    background-color: {bgColor};
    color: {cmdColor}
  ]]
  style = "QPlainTextEdit {" .. style .. "}" -- not included in the f call due to the {}
  setCmdLineStyleSheet(REPLet.console.name, style)
end

function REPLet.run(codeString)
  if codeString == "" then
    REPLet.console:echo(REPLet.prompt)
    return
  end
  local cmdColor = Geyser.Color.hdec(REPLet.config.cmdColor)
  REPLet.console:setFgColor(cmdColor)
  REPLet.console:echo(codeString .. "\n")
  REPLet.console:setFgColor(REPLet.config.fgColor)

  if codeString == "clear" then
    REPLet.clear()
    return
  end

  if codeString == "config" then
    REPLet.console:display(REPLet.config)
    REPLet.console:echo(REPLet.prompt)
    return
  end

  local fontSize = tonumber(codeString:match("^fontSize (%d+)$"))
  if fontSize then
    REPLet.config.fontSize = fontSize
    REPLet.console:setFontSize(fontSize)
    REPLet.console:echo("Set fontSize to: " .. fontSize .. "\n")
    REPLet.console:echo(REPLet.prompt)
    REPLet.styleCmdline()
    return
  end

  local font = codeString:match("^font (.+)")
  if font then
    REPLet.config.font = font
    REPLet.console:setFont(font)
    REPLet.console:echo("Set font to: " .. font .. "\n")
    REPLet.console:echo(REPLet.prompt)
    REPLet.styleCmdline()
    return
  end

  if codeString == "exit" or codeString == "close" then
    REPLet.console:echo(REPLet.prompt)
    REPLet.container:hide()
    return
  end

  local autoWrap = codeString:match("^autoWrap (%w+)$")
  if autoWrap then
    if autoWrap == "false" then
      REPLet.config.autoWrap = false
      REPLet.console:echo("Disabled Autowrap\n")
      REPLet.console:disableAutoWrap()
    else
      REPLet.config.autoWrap = true
      REPLet.console:echo("Enabled Autowrap\n")
      REPLet.console:enableAutoWrap()
    end
    REPLet.console:echo(REPLet.prompt)
    return
  end

  local addEchos = codeString:match("^addEchos (%w+)$")
  if addEchos then
    if addEchos == "false" then
      REPLet.config.addEchos = false
      REPLet.console:echo("Disabled addEchos\n")
      REPLet.console:disableAutoWrap()
    else
      REPLet.config.addEchos = true
      REPLet.console:echo("Enabled addEchos\n")
      REPLet.console:enableAutoWrap()
    end
    REPLet.console:echo(REPLet.prompt)
    return
  end

  local fgColor = codeString:match("^fgColor (.+)")
  if fgColor then
    REPLet.config.fgColor = fgColor
    REPLet.console:setFgColor(fgColor)
    REPLet.console:echo("Set fgColor to: " .. fgColor .. "\n")
    REPLet.console:echo(REPLet.prompt)
    return
  end

  local borderColor = codeString:match("^borderColor (.+)")
  if borderColor then
    REPLet.config.borderColor = borderColor
    REPLet.styleCmdline()
    REPLet.console:echo("Set borderColor to: " .. borderColor .. "\n")
    REPLet.console:echo(REPLet.prompt)
    return
  end

  local borderThickness = tonumber(codeString:match("^borderThickness (%d+)"))
  if borderThickness then
    REPLet.config.borderThickness = borderThickness
    REPLet.styleCmdline()
    REPLet.console:echo("Set borderThickness to: " .. borderThickness .. "\n")
    REPLet.console:echo(REPLet.prompt)
    return
  end

  local CMDColor = codeString:match("^cmdColor (.+)")
  if CMDColor then
    REPLet.config.cmdColor = CMDColor
    REPLet.console:echo("Set cmdColor to: " .. CMDColor .. "\n")
    REPLet.console:echo(REPLet.prompt)
    REPLet.styleCmdline()
    return
  end

  local color = codeString:match("^color (.+)")
  if color then
    REPLet.config.color = color
    REPLet.console:setColor(color)
    REPLet.console:echo("Set color to: " .. color .. "\n")
    REPLet.console:echo(REPLet.prompt)
    REPLet.styleCmdline()
    return
  end

  if codeString == "load" then
    REPLet.load()
    REPLet.console:echo("Loaded REPLet config\n")
    REPLet.console:echo(REPLet.prompt)
    return
  end

  if codeString == "save" then
    REPLet.save()
    REPLet.console:echo("Saved REPLet config\n")
    REPLet.console:echo(REPLet.prompt)
    return
  end

  if codeString == "usage" then
    REPLet.usage()
    return
  end
  REPLet.addEchos()

  local func, err = loadstring("return " .. codeString)
  if not func then
    func, err = loadstring(codeString)
  end
  if not func then
    REPLet.error(err)
    REPLet.removeEchos()
    return
  end
  local printRes = function(ok,...)
    if ok then
      REPLet.console:echo("---- OUTPUT ----\n")
      REPLet.console:display(...)
      return
    end
    REPLet.error(...)
  end
  printRes(pcall(func))
  REPLet.removeEchos()
  REPLet.console:echo(REPLet.prompt)
end

function REPLet.clear()
  REPLet.console:clear()
  REPLet.console:echo(REPLet.intro)
  REPLet.console:echo(REPLet.prompt)
end

function REPLet.init()
  REPLet.load()
  REPLet.container = Geyser.UserWindow:new({
    name = "REPLet Lua REPL window",
    x = 100,
    y = 100,
    height = 400,
    width = 800,
    autoDock = false,
    titleText = "REPLet: Mudlet Lua REPL",
    restoreLayout = false,
  })
  REPLet.console = Geyser.MiniConsole:new({
    name = "REPLET.console",
    x = 0,
    y = 0,
    height = "100%",
    width = "100%",
    commandLine = true,
    font = REPLet.config.font,
    fontSize = REPLet.config.fontSize,
    fgColor = REPLet.config.fgColor,
    color = REPLet.config.color,
    autoWrap = REPLet.config.autoWrap
  }, REPLet.container)
  REPLet.console:setFgColor(REPLet.config.fgColor)
  REPLet.console:setCmdAction(REPLet.run)
  REPLet.styleCmdline()
  REPLet.clear()
  REPLet.container:show()
end

if REPLet.eventHandler then
  killAnonymousEventHandler(REPLet.eventHandler)
end
REPLet.eventHandler = registerAnonymousEventHandler("sysExitEvent", REPLet.save)