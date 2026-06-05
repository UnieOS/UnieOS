function Test-IsRoot {
    return (id -u) -eq 0
}
# Even though this code is PowerShell, it's still written for Linux (Microsoft also maintains PowerShell for Linux).
# This code is written by LLMs, and due to the lack of computers at the moment, it cannot be tested. If there are any consequences, please don't report us, just let us know.
function Assert-SudoPrivileges {
    if (-not (Test-IsRoot)) {
        $scriptPath = $MyInvocation.ScriptName
        if ([string]::IsNullOrEmpty($scriptPath)) {
            $scriptPath = $PSCommandPath
        }
        sudo pwsh -NoProfile -ExecutionPolicy Bypass -File $scriptPath
        Exit
    }
}

Export-ModuleMember -Function Assert-SudoPrivileges

