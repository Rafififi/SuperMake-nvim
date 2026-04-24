local M = {}

local function map(arr, f)
  local res = {}
  for i, v in pairs(arr) do
    res[i] = f(v)
  end
  return res
end

local function filter(arr, f)
  local res = {}
  for i, v in pairs(arr) do
    if f(v) then
      res[i] = v
    end
  end
  return res
end

local function cut(s, sep)
    local found = string.find(s, sep)
    if found then
      return {string.sub(s, 1, found - 1), string.sub(s, found + 1, #s)}
    end
    return s
end

function PrintTable(t, indent)
    indent = indent or 0
    for k, v in pairs(t) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            PrintTable(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

local function indices(t)
  local keys = {}
  for k, _ in pairs(t) do
    table.insert(keys, k)
  end
  return keys
end

local function get_target(t, line_num)
  if not t then
    return 1
  end
  local prev = t[1]
  for _, v in pairs(t) do
    if line_num < v and prev < line_num then
      return prev
    end
    if line_num == v then
      return v
    end
    prev = v
  end
  return prev
end

local function get_next(t, v, max)
  for idx, val in pairs(t) do
    if val == v then
      if t[idx+1] then
        return t[idx+1]
      else
        return max
      end
    end
  end
end

local function get_target_lines(lines)
  local target_lines   = filter(map(lines, function(line) return cut(line, ":") end), function(line) return #line == 2 end)
  local argument_lines = filter(map(lines, function(line) return cut(line, "-") end), function(line) return #line == 2 end)
  target_lines = map(target_lines, function (line) return {line[2], line[1]} end)
  argument_lines = map(argument_lines, function (line) return line[2] end)
  return {target_lines, argument_lines}
end

local function get_choice(lines, line_num)
  local num_lines = #lines
  lines = get_target_lines(lines)
  local targets = lines[1]
  local arguments = lines[2]
  if targets == nil then
    return ""
  end
  local target_indices = indices(targets)
  local selected_idx = get_target(target_indices, line_num)
  local selected_target = targets[selected_idx]
  local final_idx = get_next(target_indices, selected_idx, num_lines)

  local s1 = selected_target[1] .. " " .. selected_target[2]
  local s2 = ""
  for idx, val in pairs(arguments) do
    if idx > selected_idx and idx < final_idx then
      s2 = s2 .. " " .. val
    end
  end
  return s1 .. " " .. s2
end

M.get_choice = get_choice

return M
