-- Shared helpers for recognizing VCS / diff "virtual" buffers (CodeDiff,
-- Diffview, Gitsigns, Fugitive) and pulling out a (filename, revision) pair.
-- Used by both dropbar (winbar breadcrumbs) and incline (floating label) so the
-- two stay in sync about what counts as a diff buffer and how revs are shown.
local M = {}

-- Parse a buffer name. Returns (filepath, revision) for VCS buffers, else nil.
function M.parse(name)
  -- CodeDiff: codediff:///<git-root>///<commit>/<filepath>
  local commit, path = name:match "^codediff:///.-///([^/]+)/(.+)$"
  if commit then
    return path, commit
  end

  -- Diffview: diffview://<dir>/<context>/<path>  (context = abbrev sha, :N:, or [custom])
  path = name:match "^diffview://.*/%[custom%]/(.+)$"
  if path then
    return path, "custom"
  end
  local stage
  stage, path = name:match "^diffview://.*/(:%d+:)/(.+)$"
  if path then
    return path, stage
  end
  commit, path = name:match "^diffview://.*/(%x+)/(.+)$"
  if commit then
    return path, commit
  end

  -- Gitsigns: gitsigns://<gitdir>//<rev>:<relpath>
  local rev
  rev, path = name:match "^gitsigns://.-//([^:]+):(.+)$"
  if rev then
    return path, rev
  end

  -- Fugitive: fugitive://<gitdir>//<sha><path>  (sha is 40 hex chars, or 0 for index)
  commit, path = name:match "^fugitive://.-//(%x+)(/.+)$"
  if commit then
    return path, commit
  end

  return nil
end

-- Shorten a revision for display: 40/11-char shas -> 7 chars, leave refs/stages as-is.
function M.short_rev(rev)
  if rev:match "^%x+$" and #rev >= 7 then
    return rev:sub(1, 7)
  end
  return rev
end

return M
