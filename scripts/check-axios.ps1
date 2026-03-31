param(
    [string]$TargetPath = "."
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$TargetPath = Resolve-Path $TargetPath
$dangerousVersions = @("axios@1.14.1", "axios@0.30.4")
$projects = @()
$detected = @()

Write-Host "`n=== axios 악성 버전 검사 ===" -ForegroundColor Cyan
Write-Host "검사 경로: $TargetPath`n"

# package.json 재귀 탐색 (node_modules 내부 제외)
Get-ChildItem -Path $TargetPath -Filter "package.json" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\node_modules\\" } |
    ForEach-Object {
        $projectDir = $_.DirectoryName
        $nodeModules = Join-Path $projectDir "node_modules"

        if (Test-Path $nodeModules) {
            $projects += $projectDir
            Write-Host "[검사중] $projectDir" -ForegroundColor Yellow

            try {
                $output = & npm ls axios 2>&1 | Out-String
                foreach ($ver in $dangerousVersions) {
                    if ($output -match [regex]::Escape($ver)) {
                        $detected += [PSCustomObject]@{
                            Path    = $projectDir
                            Version = $ver
                        }
                        Write-Host "  [위험] $ver 감지!" -ForegroundColor Red
                    }
                }
            }
            catch {
                Write-Host "  [오류] npm ls 실행 실패: $_" -ForegroundColor DarkGray
            }
        }
    }

# 결과 요약
Write-Host "`n=== 검사 결과 ===" -ForegroundColor Cyan
Write-Host "검사한 프로젝트: $($projects.Count)개"

if ($detected.Count -gt 0) {
    Write-Host "위험 감지: $($detected.Count)건`n" -ForegroundColor Red
    $detected | Format-Table -Property Path, Version -AutoSize
    Write-Host "즉시 npm install axios@latest 로 업데이트하세요!" -ForegroundColor Red
}
else {
    Write-Host "위험한 axios 버전이 발견되지 않았습니다." -ForegroundColor Green
}
