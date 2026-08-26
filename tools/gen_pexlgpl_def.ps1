# Generates a definition file with all the exported symbols in the given DLLS.
#
# Exported *data* (variables, not functions) is emitted with the DATA keyword.
# Without it the linker creates a callable thunk under the undecorated name, so
# consumers using the __declspec(dllimport) view fail to link with
# 'unresolved external symbol __imp_<name>', while consumers using the plain
# 'extern' view silently read the address of the thunk instead of the variable.
#
# Whether an export is data is decided by looking up its RVA in the section
# headers of the DLL: everything that does not land in an executable section is
# data.
#
# IMPORTANT: dumpbin must be on your path, or, execute this from a "Native tools command prompt"
#
# Examples:
# powershell pexlgpl\tools\gen_pexlgpl_def.ps1 -path C:\pexip\media\.build\windows-amd64\__install__ -files gio-2.0-0.dll,glib-2.0-0.dll,gmodule-2.0-0.dll,gobject-2.0-0.dll,nice.dll,json-glib-1.0-0.dll,pexrtmpserver.dll -out C:\pexip\media\media\lgpl\data\pexlgpl.def
#

param (
    [Parameter(Mandatory=$true)]
    [string]$path,
    [Parameter(Mandatory=$true)]
    [string[]]$files,
    [Parameter(Mandatory=$false)]
    [string]$out = 'pexlgpl.def'
)

$ErrorActionPreference = "Stop"
$cmd = (Get-WmiObject win32_process -Filter ProcessId=$PID -Property CommandLine).CommandLine

# Returns the sections of a DLL, parsed out of 'dumpbin /headers', as objects
# with Start, End and IsExecutable.
function Get-Sections($dll) {
    $sections = @()
    $current = $null

    dumpbin /nologo /headers $dll | ForEach-Object {
        if ($_ -match '^SECTION HEADER #') {
            if ($current) { $sections += $current }
            $current = [PSCustomObject]@{ Start = 0; Size = 0; End = 0; IsExecutable = $false }
        } elseif ($current) {
            if ($_ -match '^\s+([0-9A-Fa-f]+) virtual size') {
                $current.Size = [Convert]::ToUInt32($matches[1], 16)
            } elseif ($_ -match '^\s+([0-9A-Fa-f]+) virtual address') {
                $current.Start = [Convert]::ToUInt32($matches[1], 16)
            } elseif ($_ -match '^\s+Execute') {
                $current.IsExecutable = $true
            }
        }
    }

    if ($current) { $sections += $current }

    foreach ($s in $sections) { $s.End = $s.Start + $s.Size }
    return $sections
}

# An export is data when its RVA lands in a section that is not executable.
function Test-IsData($sections, $rva) {
    foreach ($s in $sections) {
        if ($rva -ge $s.Start -and $rva -lt $s.End) {
            return (-not $s.IsExecutable)
        }
    }
    return $false
}

Set-Content $out "; Generated on $(Get-Date)"
Add-Content $out "; Command line: $cmd"
Add-Content $out ""
Add-Content $out "EXPORTS"
foreach ($f in $files) {
    $fpath = Get-ChildItem $path -Filter "$f*.dll" -File -Recurse | Select-Object -First 1 -ExpandProperty FullName

    if ($fpath) {
        Write-Host "[+] Dumping $fpath..."
        Add-Content -Path $out "; $fpath"

        $sections = Get-Sections $fpath

        dumpbin /nologo /exports $fpath | Foreach-Object {
            $name = $_.split("=")[1]
            if (-not $name) { return }

            # the export lines are 'ordinal hint RVA name', and the RVA is what
            # tells us whether this export is data or code
            if ($_ -match '^\s*\d+\s+[0-9A-Fa-f]+\s+([0-9A-Fa-f]+)\s') {
                $rva = [Convert]::ToUInt32($matches[1], 16)
                if (Test-IsData $sections $rva) {
                    return "$($name.TrimEnd()) DATA"
                }
            }

            return $name
        } | Add-Content $out
    } else {
        Write-Host "[!] Skipping missing $f!"
    }
}

Write-Host "[+] Created $out"
