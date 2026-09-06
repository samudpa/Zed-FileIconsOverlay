[CmdletBinding(SupportsShouldProcess = $true)]
Param(
    [Parameter()][string]$IconRoot = "$env:LOCALAPPDATA\ZedFileIcons\file-icons",
    [Parameter()][string]$ProgIdPrefix = "Zed"
)

$ErrorActionPreference = 'Stop'

$IconByExt = @{
    'c'='c.ico'; 'h'='c.ico'; 'm'='c.ico'
    'c++'='cpp.ico'; 'cc'='cpp.ico'; 'cp'='cpp.ico'; 'cpp'='cpp.ico'; 'cxx'='cpp.ico'; 'h++'='cpp.ico'; 'hh'='cpp.ico'; 'hpp'='cpp.ico'; 'hxx'='cpp.ico'; 'ii'='cpp.ico'; 'inl'='cpp.ico'; 'ipp'='cpp.ico'; 'mm'='cpp.ico'; 'tpp'='cpp.ico'
    'cake'='csharp.ico'; 'cs'='csharp.ico'; 'cshtml'='csharp.ico'; 'csproj'='csharp.ico'; 'csx'='csharp.ico'
    'css'='css.ico'
    'ascx'='html.ico'; 'asp'='html.ico'; 'aspx'='html.ico'; 'eex'='html.ico'; 'heex'='html.ico'; 'htm'='html.ico'; 'html'='html.ico'; 'jshtm'='html.ico'; 'razor'='html.ico'; 'shtml'='html.ico'; 'xhtml'='html.ico'
    'cjs'='javascript.ico'; 'coffee'='javascript.ico'; 'iced'='javascript.ico'; 'js'='javascript.ico'; 'jscsrc'='javascript.ico'; 'jshintrc'='javascript.ico'; 'litcoffee'='javascript.ico'; 'mjs'='javascript.ico'
    'ctsx'='react.ico'; 'jsx'='react.ico'; 'mtsx'='react.ico'; 'tsx'='react.ico'
    'cts'='typescript.ico'; 'mts'='typescript.ico'; 'ts'='typescript.ico'
    'ipynb'='json.ico'; 'json'='json.ico'; 'json5'='json.ico'; 'jsonc'='json.ico'; 'jsonl'='json.ico'; 'jsonld'='json.ico'; 'map'='json.ico'; 'ndjson'='json.ico'; 'tsbuildinfo'='json.ico'; 'webmanifest'='json.ico'
    'livemd'='markdown.ico'; 'markdown'='markdown.ico'; 'md'='markdown.ico'; 'mdoc'='markdown.ico'; 'mdown'='markdown.ico'; 'mdtext'='markdown.ico'; 'mdtxt'='markdown.ico'; 'mdwn'='markdown.ico'; 'mdx'='markdown.ico'; 'mermaid'='markdown.ico'; 'mkd'='markdown.ico'; 'mkdn'='markdown.ico'; 'mmd'='markdown.ico'; 'qmd'='markdown.ico'; 'rmd'='markdown.ico'; 'rmdown'='markdown.ico'
    'pxd'='python.ico'; 'pxi'='python.ico'; 'py'='python.ico'; 'pyi'='python.ico'; 'pyw'='python.ico'; 'pyx'='python.ico'
    'ps1'='powershell.ico'; 'psd1'='powershell.ico'; 'psm1'='powershell.ico'
    'ash'='shell.ico'; 'bash'='shell.ico'; 'bash_login'='shell.ico'; 'bash_logout'='shell.ico'; 'bash_profile'='shell.ico'; 'bashrc'='shell.ico'; 'csh'='shell.ico'; 'cshrc'='shell.ico'; 'dash'='shell.ico'; 'fish'='shell.ico'; 'ksh'='shell.ico'; 'kshrc'='shell.ico'; 'mksh'='shell.ico'; 'profile'='shell.ico'; 'sh'='shell.ico'; 'tcsh'='shell.ico'; 'tcshrc'='shell.ico'; 'zlogin'='shell.ico'; 'zlogout'='shell.ico'; 'zprofile'='shell.ico'; 'zshenv'='shell.ico'; 'zsh'='shell.ico'; 'zshrc'='shell.ico'
    'axaml'='xml.ico'; 'clixml'='xml.ico'; 'dita'='xml.ico'; 'ditamap'='xml.ico'; 'dtd'='xml.ico'; 'plist'='xml.ico'; 'props'='xml.ico'; 'ps1xml'='xml.ico'; 'resx'='xml.ico'; 'svg'='xml.ico'; 'targets'='xml.ico'; 'vsixmanifest'='xml.ico'; 'wxi'='xml.ico'; 'wxl'='xml.ico'; 'wxs'='xml.ico'; 'xaml'='xml.ico'; 'xib'='xml.ico'; 'xml'='xml.ico'; 'xul'='xml.ico'
    'eyaml'='yaml.ico'; 'eyml'='yaml.ico'; 'yaml'='yaml.ico'; 'yml'='yaml.ico'
    'babelrc'='config.ico'; 'cfg'='config.ico'; 'cmake'='config.ico'; 'condarc'='config.ico'; 'conf'='config.ico'; 'config'='config.ico'; 'containerfile'='config.ico'; 'dockerfile'='config.ico'; 'dockerignore'='config.ico'; 'editorconfig'='config.ico'; 'env'='config.ico'; 'eslintignore'='config.ico'; 'eslintrc'='config.ico'; 'flake8'='config.ico'; 'gitattributes'='config.ico'; 'gitconfig'='config.ico'; 'gitignore'='config.ico'; 'gitignore_global'='config.ico'; 'gitkeep'='config.ico'; 'gitmodules'='config.ico'; 'gradle'='config.ico'; 'helmignore'='config.ico'; 'ini'='config.ico'; 'lock'='config.ico'; 'npmignore'='config.ico'; 'npmrc'='config.ico'; 'pdbrc'='config.ico'; 'prettierignore'='config.ico'; 'prettierrc'='config.ico'; 'properties'='config.ico'; 'pylintrc'='config.ico'; 'slugignore'='config.ico'; 'toml'='config.ico'; 'yarnrc'='config.ico'
    'bowerrc'='bower.ico'
    'code'='code.ico'; 'code-workspace'='code.ico'
    'go'='go.ico'
    'jade'='jade.ico'; 'pug'='jade.ico'
    'jav'='java.ico'; 'java'='java.ico'; 'jsp'='java.ico'; 'jspx'='java.ico'
    'less'='less.ico'
    'php'='php.ico'; 'phtml'='php.ico'; 'php3'='php.ico'; 'php4'='php.ico'; 'php5'='php.ico'; 'phps'='php.ico'; 'phpt'='php.ico'
    'builder'='ruby.ico'; 'erb'='ruby.ico'; 'gemspec'='ruby.ico'; 'jbuilder'='ruby.ico'; 'rabl'='ruby.ico'; 'rake'='ruby.ico'; 'rb'='ruby.ico'; 'ru'='ruby.ico'
    'sass'='sass.ico'; 'scss'='sass.ico'
    'ddl'='sql.ico'; 'dml'='sql.ico'; 'mysql'='sql.ico'; 'pgsql'='sql.ico'; 'sql'='sql.ico'
    'vue'='vue.ico'
}

$ZedExtensions = @(
    'ada','adb','adoc','ads','ahk','asc','asciidoc','ascx','ash','asm','asp','aspx','astro','axaml',
    'babelrc','bash','bash_login','bash_logout','bash_profile','bashrc','bat','bats','bicep','bicepparam','bib','blade','bowerrc','bsdmakefile','builder','bzl',
    'c','c++','cabal','cake','cbl','cc','cfg','cgi','chs','cjs','clj','cljc','cljs','cljx','clixml','clojure','cls','cmake','cmd','cob','code','code-workspace','coffee','condarc','conf','config','containerfile','cp','cpp','cpy','cr','cs','csh','cshrc','cshtml','csproj','css','csv','csx','ctp','cts','ctsx','cue','cxx',
    'd','dart','dash','ddl','dhall','diff','dita','ditamap','dml','dockerfile','dockerignore','dot','dpr','dtd',
    'ecr','editorconfig','edn','eex','ejs','el','elm','elc','env','erb','erl','eslintignore','eslintrc','ex','exs','eyaml','eyml',
    'f','f03','f08','f77','f90','f95','fbs','fish','flake8','for','fs','fsi','fsproj','fsscript','fsx','ftn',
    'gemspec','gitattributes','gitconfig','gitignore','gitignore_global','gitkeep','gitmodules','gleam','gn','gni','go','gql','gradle','graphql','graphqls','groovy','gsh','gvy','gy',
    'h','h++','handlebars','hbs','hcl','heex','helmignore','hh','hpp','hrl','hs','hsc','htm','html','hxx',
    'iced','ii','inc','ini','inl','ipynb','ipp',
    'jade','jav','java','jbuilder','jinja','jinja2','jl','js','jscsrc','jshintrc','jshtm','json','json5','jsonc','jsonl','jsonld','jsp','jspx','jsx','justfile',
    'ksh','kshrc','kt','ktm','kts',
    'less','lhs','liquid','lisp','litcoffee','livemd','lock','log','lpr','lua','luau',
    'm','m4','makefile','map','markdown','md','mdoc','mdown','mdtext','mdtxt','mdwn','mdx','mermaid','mjs','mk','mkd','mkdn','ml','mli','mll','mly','mm','mmd','mksh','mts','mtsx','mustache','mysql',
    'nasm','ndjson','nim','nimble','nims','nix','njk','nomad','npmignore','npmrc',
    'org',
    'pas','pcss','pdbrc','pgsql','phtml','php','php3','php4','php5','phps','phpt','pkl','pl','pl6','plist','pm','pm6','pod','postcss','pp','prettierignore','prettierrc','pri','pro','procfile','profile','prolog','properties','props','proto','ps1','ps1xml','psd1','psgi','psm1','pssc','psrc','pug','pxd','pxi','py','pyi','pylintrc','pyw','pyx',
    'qmd',
    'r','rake','rabl','razor','rb','reg','resx','rhistory','rkt','rktd','rktl','rmd','rmdown','rnw','rprofile','rs','rst','rt','ru',
    's','sass','sbt','sc','scala','scm','scss','sh','shtml','sld','slugignore','sln','sps','sql','sqlite','ss','ssv','star','styl','sv','svh','svg','swift','swiftinterface',
    't','targets','tcl','tcsh','tcshrc','tex','tf','tfvars','tk','toml','tpp','ts','tsbuildinfo','tsv','tsx','tt','twig','txt',
    'v','vb','vbproj','vcxproj','vh','vim','vimrc','vsixmanifest','vsh','vue',
    'wat','wast','webmanifest','wxi','wxl','wxs',
    'xaml','xhtml','xib','xml','xul',
    'yaml','yarnrc','yml',
    'zig','zon','zlogin','zlogout','zprofile','zshenv','zsh','zshrc'
) | Sort-Object -Unique

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

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceIconRoot = Join-Path $scriptRoot 'file-icons'
if (-not (Test-Path $sourceIconRoot)) {
    throw "Missing bundled file-icons directory next to install.ps1"
}

if ($PSCmdlet.ShouldProcess($IconRoot, 'Copy Zed Explorer file icon assets')) {
    New-Item -Path $IconRoot -ItemType Directory -Force | Out-Null
    Copy-Item -Path (Join-Path $sourceIconRoot '*.ico') -Destination $IconRoot -Force
}

$written = 0
$missing = 0
foreach ($ext in $ZedExtensions) {
    $progId = "$ProgIdPrefix.$ext"
    $progIdKey = "HKCU:\Software\Classes\$progId"
    if (-not (Test-Path $progIdKey)) {
        $missing += 1
        continue
    }

    $iconName = if ($IconByExt.ContainsKey($ext)) { $IconByExt[$ext] } else { 'default.ico' }
    $iconPath = Join-Path $IconRoot $iconName
    $defaultIconKey = Join-Path $progIdKey 'DefaultIcon'

    if ($PSCmdlet.ShouldProcess($defaultIconKey, "Set default icon to $iconPath")) {
        New-Item -Path $defaultIconKey -Force | Out-Null
        Set-Item -Path $defaultIconKey -Value $iconPath
        $written += 1
    }
}

$sourceFileKey = "HKCU:\Software\Classes\${ProgIdPrefix}SourceFile\DefaultIcon"
if (Test-Path "HKCU:\Software\Classes\${ProgIdPrefix}SourceFile") {
    $defaultIcon = Join-Path $IconRoot 'default.ico'
    if ($PSCmdlet.ShouldProcess($sourceFileKey, "Set default icon to $defaultIcon")) {
        New-Item -Path $sourceFileKey -Force | Out-Null
        Set-Item -Path $sourceFileKey -Value $defaultIcon
    }
}

if ($PSCmdlet.ShouldProcess('Explorer', 'Refresh shell associations')) {
    Invoke-ShellAssociationRefresh
}

Write-Host "Zed file icon overlay installed. Updated $written ProgID DefaultIcon entries."
if ($written -eq 0 -and $missing -gt 0) {
    Write-Warning "No Zed ProgIDs found. Install official Stable Zed with file associations enabled, then rerun this script."
} elseif ($missing -gt 0) {
    Write-Host "Skipped $missing suffixes without a Zed ProgID on this machine; they will sync when Zed registers them."
}
Write-Host "If Explorer still shows cached icons, sign out/in or clear the Windows icon cache."
