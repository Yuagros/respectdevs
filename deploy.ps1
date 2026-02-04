# deploy.ps1 - ultra-safe one-command deploy for RespectDevs site

# Backup existing root index.html if it exists
if (Test-Path ".\index.html") {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = ".\index_backup_$timestamp.html"
    Copy-Item ".\index.html" $backupFile
    Write-Host "Backed up existing index.html to $backupFile"
}

# Move index.html from templates to root if it exists
if (Test-Path ".\templates\index.html") {
    Move-Item ".\templates\index.html" ".\index.html" -Force
    Write-Host "Moved index.html to root"
}

# Check for changes
$changes = git status --porcelain

if ($changes) {
    # Add all changes
    git add .

    # Auto-generate commit message based on modified files
    $modifiedFiles = git status --short | ForEach-Object { $_.Substring(3) } | Out-String
    $commitMessage = "Update site: " + $modifiedFiles.Trim()

    git commit -m "$commitMessage"
    Write-Host "Committed changes: $commitMessage"

    # Push to remote
    git push
    Write-Host "Pushed to GitHub. Deployment triggered!"
} else {
    Write-Host "No changes detected. Nothing to commit or push."
}

Write-Host "Done! Visit https://respectdevs.pages.dev to check your site."
