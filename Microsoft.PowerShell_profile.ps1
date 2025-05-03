[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Define colorful prompt with full path, Git status, and exit code
function prompt {
    $esc = [char]27
    $reset = "$esc[0m"

    # Foreground
    $fgWhite = "$esc[97m"
    $fgBlack = "$esc[30m"

    # Background
    $bgBlue   = "$esc[44m"
    $bgCyan   = "$esc[46m"
    $bgRed    = "$esc[41m"

    # Capture the real last exit code *before* Git runs
    $actualLastExit = $global:LASTEXITCODE

    # Path section
    $cwd = (Get-Location).Path
    $pathSection = "$bgBlue$fgWhite $cwd $reset"

    # Git section (safe, doesn't override LASTEXITCODE)
    $gitSection = ""
    $insideGit = git rev-parse --is-inside-work-tree 2>$null
    if ($insideGit) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        $status = git status --porcelain 2>$null
        $isDirty = if ($status) { " (dirty)" } else { "" }
        $gitSection = "$bgCyan$fgBlack git:$branch$isDirty $reset"
    }

    # Exit code section
    $exitSection = if ($actualLastExit -ne 0) {
        "$bgRed$fgWhite exit $actualLastExit $reset"
    } else { "" }

    # Restore exit code in case Git modified it
    $global:LASTEXITCODE = $actualLastExit

    # Final prompt string
    "$pathSection $gitSection $exitSection`n-> "
}


if (Get-Alias ls -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls
}

# Redefine ls as a function
function ls {
    eza --icons
}


function ll { eza --icons -l }
function la { eza --icons -a }
function vim { nvim }
function gs { git status }
function ga { git add }

winfetch
