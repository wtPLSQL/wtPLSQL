# md-to-htm.lua
-- Adapted from answer by JW https://stackoverflow.com/users/4321/jw
--   at https://stackoverflow.com/questions/40993488
function Link(el)
  el.target = string.gsub(el.target, "%.md", ".htm")
  return el
end