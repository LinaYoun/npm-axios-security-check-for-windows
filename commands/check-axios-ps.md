사용자가 지정한 폴더 경로: $ARGUMENTS (없으면 현재 작업 디렉토리 사용)

## 작업

이 프로젝트의 `check-axios.ps1` PowerShell 스크립트를 실행하여 악성 axios 버전(1.14.1, 0.30.4)을 검출합니다.

## 절차

1. 아래 명령을 Bash 도구로 실행한다:

```
powershell -ExecutionPolicy Bypass -File "./check-axios.ps1" -TargetPath "<대상경로>"
```

- `<대상경로>`는 사용자가 $ARGUMENTS로 지정한 경로이다. 없으면 `.`을 사용한다.
- 스크립트 경로는 `.claude/scripts/check-axios.ps1`이다.

2. 스크립트 출력을 그대로 사용자에게 보여준다.
3. 위험이 감지된 경우, 해당 프로젝트에서 `npm install axios@latest`로 업데이트할 것을 권고한다.
