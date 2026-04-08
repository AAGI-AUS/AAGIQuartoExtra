-- Enforce no List of Figures for short-report DOCX output.
function Meta(meta)
  if FORMAT and FORMAT:match("docx") then
    meta.lof = pandoc.MetaBool(false)
  end
  return meta
end
