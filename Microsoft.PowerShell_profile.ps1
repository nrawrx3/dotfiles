$env:Path += ";C:\Users\soumi\AppData\Local\Programs\oh-my-posh\bin"

Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Set-PoshPrompt -Theme paradox
# Set the oh-my-posh theme
# oh-my-posh init pwsh --config "$HOME\AppData\Local\Programs\oh-my-posh\themes\jandedobbeleer.omp.json" | Out-String

# Initialize Oh-My-Posh for PowerShell
oh-my-posh init pwsh --config "$HOME\AppData\Local\Programs\oh-my-posh\themes\lightgreen.omp.json" | Invoke-Expression


# Import PSReadLine if not already imported
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Import-Module PSReadLine
}

# Bind Up arrow to search history using prefix of typed command
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Start an incremental search on Ctrl+R
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
