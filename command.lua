-- Pretty much just a shell --

local cmd = {}

local exit = false
local path = "/dos;/dos/programs;/programs"
local currentPwd = "/"

-- Execute programs from the path
function cmd.exec(program, ...)
  checkArg(1, program, "string")
  local paths = path:tokenize(";")
  paths:insert(currentPwd)
  local programPath = ""
  local programEnv = table.copy(cmd)
  setmetatable(programEnv, { __index = _G })
  local drive = fs.getDrive() -- The current drive
  for p=1, #paths, 1 do
    if fs.exists(drive .. paths[p]) then
      programPath = drive .. paths[p]
    end
  end
  if program:sub(2,2) == ":" then
    if fs.exists(program) then
      programPath = program
    end
  end
  local ok, err = loadfile(programPath, programEnv)
  if not ok then
    error(err)
  end
  return ok()
end

print("Welcome to OC-DOS")

while not exit do
  write(fs.concat(fs.getDrive(), currentPwd) .. "> ")
  local command = read()
  local command = command:tokenize(" ")
  local status, returned = pcall(function()cmd.exec(table.unpack(command))end)
end
