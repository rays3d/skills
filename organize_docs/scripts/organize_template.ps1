<#
.SYNOPSIS
    Template script for organizing documentation using the organize_documentation skill.

.DESCRIPTION
    This script provides a starting point for moving files based on a mapping hashtable.
    It handles directory creation, file moving, and appending "Last Updated" metadata.

.EXAMPLE
    1. Update the $baseDir variable to point to your docs folder.
    2. Fill in the $mapping hashtable with your plan.
    3. Run the script.
#>

$baseDir = "path/to/docs"  # TODO: Update this path!
$date = Get-Date -Format "yyyy-MM-dd"

# mapping: "Old/Path/File.md" = "New/Category/clean-name.md"
$mapping = @{
    # "old/folder/weird_name.md" = "new/category/clean-name.md"
    # "root_file.md"             = "getting-started/root-file.md"
}

Write-Host "Starting documentation reorganization in: $baseDir"

foreach ($oldPath in $mapping.Keys) {
    $sourcePath = Join-Path $baseDir $oldPath
    $newPath = $mapping[$oldPath]
    $destPath = Join-Path $baseDir $newPath

    if (Test-Path $sourcePath) {
        # Ensure destination directory exists
        $destDir = Split-Path $destPath -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            Write-Host "Created directory: $destDir" -ForegroundColor Cyan
        }

        # Move the file
        Move-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "Moved: $oldPath -> $newPath" -ForegroundColor Green

        # Append "Last Updated" metadata
        if ($destPath.EndsWith(".md")) {
            $content = Get-Content -Path $destPath -Raw
            if ($content -match "Last Updated:") {
                $content = $content -replace "Last Updated:.*", "Last Updated: $date"
            } else {
                $content += "`n`nLast Updated: $date"
            }
            Set-Content -Path $destPath -Value $content
        }
    } else {
        Write-Warning "Source file not found: $sourcePath"
    }
}

# Cleanup empty directories
Write-Host "Cleaning up empty directories..."
Get-ChildItem -Path $baseDir -Recurse -Directory | Sort-Object -Property FullName -Descending | Where-Object {
    ($_ | Get-ChildItem).Count -eq 0
} | Remove-Item -Force

Write-Host "Done!" -ForegroundColor Green
