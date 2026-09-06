[CmdletBinding(SupportsShouldProcess = $true)]
Param(
    [Parameter()][string]$IconRoot = "$env:LOCALAPPDATA\ZedFileIcons\file-icons",
    [Parameter()][string]$ProgIdPrefix = "Zed"
)

$ErrorActionPreference = 'Stop'

function Invoke-ShellAssociationRefresh {
    $source = @"
using System;
using System.Runtime.InteropServices;

public static class ShellRefresh {
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(int wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
}
"@
    Add-Type -TypeDefinition $source -ErrorAction SilentlyContinue
    [ShellRefresh]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)
}

function Test-OverlayIconPath {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    return $Path.StartsWith("$IconRoot\", [System.StringComparison]::OrdinalIgnoreCase) -and
           $Path.EndsWith('.ico', [System.StringComparison]::OrdinalIgnoreCase)
}

$removed = 0
foreach ($progId in Get-ChildItem -Path "HKCU:\Software\Classes\$ProgIdPrefix.*" -ErrorAction SilentlyContinue) {
    $defaultIconKey = Join-Path $progId.PSPath 'DefaultIcon'
    if (Test-Path -LiteralPath $defaultIconKey) {
        $value = (Get-ItemProperty -LiteralPath $defaultIconKey -ErrorAction SilentlyContinue).'(default)'
        if (Test-OverlayIconPath $value) {
            if ($PSCmdlet.ShouldProcess($defaultIconKey, 'Remove overlay DefaultIcon key')) {
                Remove-Item -LiteralPath $defaultIconKey -Recurse -Force
                $removed += 1
            }
        }
    }
}

$sourceFileKey = "HKCU:\Software\Classes\${ProgIdPrefix}SourceFile\DefaultIcon"
if (Test-Path -LiteralPath $sourceFileKey) {
    $value = (Get-ItemProperty -LiteralPath $sourceFileKey -ErrorAction SilentlyContinue).'(default)'
    if (Test-OverlayIconPath $value) {
        if ($PSCmdlet.ShouldProcess($sourceFileKey, 'Remove overlay SourceFile DefaultIcon key')) {
            Remove-Item -LiteralPath $sourceFileKey -Recurse -Force
        }
    }
}

$iconParent = Split-Path -Parent $IconRoot
if (Test-Path -LiteralPath $iconParent) {
    if ($PSCmdlet.ShouldProcess($iconParent, 'Remove copied Zed file icon assets')) {
        Remove-Item -LiteralPath $iconParent -Recurse -Force
    }
}

if ($PSCmdlet.ShouldProcess('Explorer', 'Refresh shell associations')) {
    Invoke-ShellAssociationRefresh
}

Write-Host "Zed file icon overlay removed. Removed $removed DefaultIcon keys."
