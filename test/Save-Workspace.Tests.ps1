Describe 'Initialize-WorkspaceDb' {
    BeforeAll {
        . $PSScriptRoot\..\src\Initialize-WorkspaceDb.ps1
        . $PSScriptRoot\..\src\Save-Workspace.ps1
    }

    BeforeEach {
        Remove-Item ./tosh.json -ErrorAction Ignore
    }

    It 'Should create file' {
        Initialize-WorkspaceDb -Source ./tosh.json

        Test-Path ./tosh.json | Should Be $true
    }

    It 'Should contain empty json' {
        Initialize-WorkspaceDb -Source ./tosh.json

        $sut = Get-Content ./tosh.json | Out-String | ConvertFrom-Json
        $sut | Should Not Be $null
    }
}

Describe 'Save-Workspace' {

    BeforeEach {
        Remove-Item ./tosh.json -ErrorAction Ignore
    }

    It 'Should create source When not exist' {
        Save-Workspace -Name users -Path c:\users -Source ./tosh.json

        Test-Path ./tosh.json | Should Be $true
    }

    It 'Should save workspace' {
        Save-Workspace -Name users -Path c:\users -Source ./tosh.json
        
        $sut = Get-Content ./tosh.json | Out-String | ConvertFrom-Json
        $sut.workspaces.users | Should Be 'c:\users'
    }

    It 'Should overwrite workspace' {
        Save-Workspace -Name users -Path c:\users -Source ./tosh.json
        Save-Workspace -Name users -Path c:\overwrite -Source ./tosh.json

        $sut= Get-Content ./tosh.json | Out-String | ConvertFrom-Json
        $sut.workspaces.users | Should Be 'c:\overwrite'
    }
}
