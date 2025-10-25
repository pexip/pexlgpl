# Generates a definition file with all the exportd function in the given DLLS.
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

Set-Content $out "; Generated on $(Get-Date)"
Add-Content $out "; Command line: $cmd"
Add-Content $out ""
Add-Content $out "EXPORTS"
foreach ($f in $files) {
    $fpath = Get-ChildItem $path -Filter "$f*.dll" -File -Recurse | Select-Object -First 1 -ExpandProperty FullName

    if ($fpath) {
        Write-Host "[+] Dumping $fpath..."
        Add-Content -Path $out "; $fpath"
        dumpbin /nologo /exports $fpath | Foreach-Object { $_.split("=")[1] } | Add-Content $out
    } else {
        Write-Host "[!] Skipping missing $f!"
    }
}

Write-Host "[+] Created $out"