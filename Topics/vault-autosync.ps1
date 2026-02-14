# Vault Auto-Sync (Windows PowerShell)
# Синхронизация vault каждые 5 минут

$VaultDir = "$env:USERPROFILE\.openclaw\vault"
$LogFile = "$env:USERPROFILE\.openclaw\vault-sync.log"

Set-Location $VaultDir

# Проверить изменения
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    "$(Get-Date): No changes" | Out-File $LogFile -Append
    exit 0
}

# Pull изменения
git pull origin main

# Добавить все изменения
git add .

# Commit с timestamp
$commitMsg = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg

# Push
git push origin main

# Лог
"$(Get-Date): Synced - $commitMsg" | Out-File $LogFile -Append
