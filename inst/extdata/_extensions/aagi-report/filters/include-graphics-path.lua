function Meta(meta)
  -- Ensure the assetpath exists in the metadata
  if not meta.assetpath then
    local dir = os.getenv("QUARTO_PROJECT_DIR")
    local styleFilePath = dir:gsub("\\", "/") .. "/_extensions/aagi-report/assets"
    meta.assetpath = pandoc.MetaString(styleFilePath)
  end
  return meta
end