function Save-Workspace(
    [string]$Name, 
    [string]$Path, 
    [string]$Source = '~/.config/tosh/tosh.json')
{
    if ((Test-Path $Source) -eq $false) {
        Initialize-WorkspaceDb -Source $Source
    }

    if (!$Path) {
        $Path = (Get-Location).Path
    }

    $data = Get-Content $Source | Out-String | ConvertFrom-Json

    $table = @{}
    $properties = $data.workspaces.Properties 

    if ($properties -ne $null) {
        $properties | ForEach { $table[$_.Name] = $_.Value }
    }

    $table[$Name] = $Path
    $data.workspaces = $table

    $data | ConvertTo-Json -depth 100 | Out-File $Source
}

function Initialize-WorkspaceDb([string]$Source)
{
    @(
        @{
            workspaces = @{}
        }
    ) | ConvertTo-Json -depth 100 | Out-File $Source
}