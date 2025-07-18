-- insert-partners-logo.lua
-- This filter inserts the Partners logo after the title block

-- Function to add content after the title block
function add_after_title(meta)
  local partner_logo = meta["partner-logo"]
  local logo_path = partner_logo and pandoc.utils.stringify(partner_logo) or ""
  if logo_path ~= "" then
    local html = [[
<style>
.partners-overlay-container {
  position: relative;
  text-align: center;
  margin-top: 20px;
  margin-bottom: 30px;
  clear: both;
  width: 130%;
  max-width: 1024px;
  aspect-ratio: 1024 / 147; /* maintain aspect ratio if supported */
}
.project-partner-img {
  width: 100%;
  height: auto;
  display: block;
}
.extra-partner-img {
  position: absolute;
  top: 30.5%;   /* adjust as needed, relative to container height */
  right: 7%;  /* adjust as needed, relative to container width */
  width: 14%; /* adjust as needed, relative to container width */
  height: auto;
  object-fit: contain;
  background: white;
  padding: 1vw 1vw;
  border-radius: 4px;
}
</style>
<div class="partners-overlay-container">
  <!-- Uncomment the line below to use a local image -->
  <!-- <img class="project-partner-img" src="_extensions/aagi-report/assets/Project_partner.png" alt="Project Partners"> -->
  <img class="project-partner-img" src="https://github.com/AAGI-AUS/AAGI-Style-Guide-and-Logos/blob/main/assets/Project_partner.svg?raw=true" alt="Project Partners">
  <img class="extra-partner-img" src="]] .. logo_path .. [[" alt="Partner Logo">
</div>
]]
    return { pandoc.RawBlock('html', html) }
  else
    local html = [[
<style>
.aagi-partners-container {
  text-align: center;
  margin-top: 20px;
  margin-bottom: 30px;
  clear: both;
  width: 130%;
}
</style>
<div class="aagi-partners-container">
  <!-- Uncomment the line below to use a local image -->
  <!-- <img src="_extensions/aagi-report/assets/Partners.png" style="max-width: 100%;" /> -->
  <img src="https://github.com/AAGI-AUS/AAGI-Style-Guide-and-Logos/blob/main/assets/Partners.svg?raw=true" style="max-width: 100%;" />
</div>
]]
    return { pandoc.RawBlock('html', html) }
  end
end

-- Main function

function Pandoc(doc)
  local new_blocks = {}
  local added_partners = false
  local meta = doc.meta

  for i, block in ipairs(doc.blocks) do
    if block.t == "Header" and block.level == 1 and not added_partners then
      for _, v in ipairs(add_after_title(meta)) do
        table.insert(new_blocks, v)
      end
      added_partners = true
    end
    table.insert(new_blocks, block)
  end

  if not added_partners then
    for _, v in ipairs(add_after_title(meta)) do
      table.insert(new_blocks, v)
    end
  end

  doc.blocks = new_blocks
  return doc
end
