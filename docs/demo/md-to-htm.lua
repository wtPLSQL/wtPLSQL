# links-to-html.lua
function Link(el)
  el.target = string.gsub(el.target, "%.md", ".htm")
  return el
end