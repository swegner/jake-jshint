$statusFile = 'build/last_status'

$oldStatus = Get-Content $statusFile

node .\node_modules\jake\bin\cli.js $args
if ($LastExitCode -eq 0) {
    newStatus="PASS"
} else {
    newStatus="FAIL"
}

$newStatus | Out-File $statusFile

if ($oldStatus -ne $newStatus) {
    git commit -a -m "Autocommit: Build state toggled to $newStatus"

    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Warning
        Write-Warning "Uncommitted files; use 'git add'"
    }
}