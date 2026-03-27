param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot
)

$patterns = @(
  @{ Name = 'yield()'; Regex = '\byield\s*\('; Replace = 'await <signal>' },
  @{ Name = 'instance()'; Regex = '\binstance\s*\('; Replace = 'instantiate()' },
  @{ Name = 'PackedScene.instance()'; Regex = 'PackedScene\.instance\s*\('; Replace = 'PackedScene.instantiate()' },
  @{ Name = 'connect(string)'; Regex = '\.connect\s*\(\s*\"[^\"]+\"\s*,'; Replace = 'signal.connect(callable)' },
  @{ Name = 'TileMap node'; Regex = '\bTileMap\b'; Replace = 'TileMapLayer' },
  @{ Name = 'YSort node'; Regex = '\bYSort\b'; Replace = 'Node2D.y_sort_enabled' },
  @{ Name = 'VisibilityNotifier2D'; Regex = '\bVisibilityNotifier2D\b'; Replace = 'VisibleOnScreenNotifier2D' },
  @{ Name = 'VisibilityNotifier3D'; Regex = '\bVisibilityNotifier3D\b'; Replace = 'VisibleOnScreenNotifier3D' }
)

Get-ChildItem -Path $ProjectRoot -Recurse -File -Filter *.gd -ErrorAction SilentlyContinue | ForEach-Object {
  $path = $_.FullName
  $content = Get-Content -Raw -ErrorAction SilentlyContinue $path
  foreach ($p in $patterns) {
    if ($content -match $p.Regex) {
      Write-Output "ERROR: API deprecada '$($p.Name)' en $path | Usar: $($p.Replace)"
    }
  }
}
