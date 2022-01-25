@echo off

rem --------------------------------
rem バケット名の設定
set BACKET_NAME=%1
if "%BACKET_NAME%" equ "" (
    echo 引数にバケット名が指定されていません。
    echo.
    goto end
)

rem --------------------------------
rem  バケット作成
echo aws s3api create-bucket --region "ap-northeast-1" --bucket %BACKET_NAME% --create-bucket-configuration LocationConstraint="ap-northeast-1"
     aws s3api create-bucket --region "ap-northeast-1" --bucket %BACKET_NAME% --create-bucket-configuration LocationConstraint="ap-northeast-1"
set RET=%ERRORLEVEL%
if %RET% gtr 0 (
    echo.
    echo CLIの戻り値 %RET%
    echo.
    echo S3バケットの作成に失敗しました。以下等の理由が考えられます。
    echo ・バケット作成権限が不足している
    echo ・バケット名に使用できない文字が入っている（アンダーバーなど）
    echo ・バケット名が重複している（全世界でユニークなバケット名がが必要です）
    echo.
    goto end
)
echo %BACKET_NAME%を作成しました。
echo.

rem --------------------------------
rem  アクセス権限の設定
echo aws s3api put-public-access-block --region "ap-northeast-1" --bucket %BACKET_NAME% --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
     aws s3api put-public-access-block --region "ap-northeast-1" --bucket %BACKET_NAME% --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
set RET=%ERRORLEVEL%
if %RET% gtr 0 (
    echo.
    echo CLIの戻り値 %RET%
    echo.
    echo S3バケットのアクセス権限の設定に失敗しました。以下等の理由が考えられます。
    echo ・権限が不足している
    echo.
    goto end
)
echo %BACKET_NAME%にアクセス権限を設定しました。
echo.

rem --------------------------------
rem  履歴の有効化
echo aws s3api put-bucket-versioning --region "ap-northeast-1" --bucket "%BACKET_NAME%" --versioning-configuration Status=Enabled
     aws s3api put-bucket-versioning --region "ap-northeast-1" --bucket "%BACKET_NAME%" --versioning-configuration Status=Enabled
set RET=%ERRORLEVEL%
if %RET% gtr 0 (
    echo.
    echo CLIの戻り値 %RET%
    echo.
    echo S3バケットの履歴の有効化に失敗しました。以下等の理由が考えられます。
    echo ・権限が不足している
    echo.
    goto end
)
echo %BACKET_NAME%の履歴を有効化しました。
echo.

:end
