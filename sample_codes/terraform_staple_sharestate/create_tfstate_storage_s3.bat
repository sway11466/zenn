@echo off

rem --------------------------------
rem �o�P�b�g���̐ݒ�
set BACKET_NAME=%1
if "%BACKET_NAME%" equ "" (
    echo �����Ƀo�P�b�g�����w�肳��Ă��܂���B
    echo.
    goto end
)

rem --------------------------------
rem  �o�P�b�g�쐬
echo aws s3api create-bucket --region "ap-northeast-1" --bucket %BACKET_NAME% --create-bucket-configuration LocationConstraint="ap-northeast-1"
     aws s3api create-bucket --region "ap-northeast-1" --bucket %BACKET_NAME% --create-bucket-configuration LocationConstraint="ap-northeast-1"
set RET=%ERRORLEVEL%
if %RET% gtr 0 (
    echo.
    echo CLI�̖߂�l %RET%
    echo.
    echo S3�o�P�b�g�̍쐬�Ɏ��s���܂����B�ȉ����̗��R���l�����܂��B
    echo �E�o�P�b�g�쐬�������s�����Ă���
    echo �E�o�P�b�g���Ɏg�p�ł��Ȃ������������Ă���i�A���_�[�o�[�Ȃǁj
    echo �E�o�P�b�g�����d�����Ă���i�S���E�Ń��j�[�N�ȃo�P�b�g�������K�v�ł��j
    echo.
    goto end
)
echo %BACKET_NAME%���쐬���܂����B
echo.

rem --------------------------------
rem  �A�N�Z�X�����̐ݒ�
echo aws s3api put-public-access-block --region "ap-northeast-1" --bucket %BACKET_NAME% --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
     aws s3api put-public-access-block --region "ap-northeast-1" --bucket %BACKET_NAME% --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
set RET=%ERRORLEVEL%
if %RET% gtr 0 (
    echo.
    echo CLI�̖߂�l %RET%
    echo.
    echo S3�o�P�b�g�̃A�N�Z�X�����̐ݒ�Ɏ��s���܂����B�ȉ����̗��R���l�����܂��B
    echo �E�������s�����Ă���
    echo.
    goto end
)
echo %BACKET_NAME%�ɃA�N�Z�X������ݒ肵�܂����B
echo.

rem --------------------------------
rem  �����̗L����
echo aws s3api put-bucket-versioning --region "ap-northeast-1" --bucket "%BACKET_NAME%" --versioning-configuration Status=Enabled
     aws s3api put-bucket-versioning --region "ap-northeast-1" --bucket "%BACKET_NAME%" --versioning-configuration Status=Enabled
set RET=%ERRORLEVEL%
if %RET% gtr 0 (
    echo.
    echo CLI�̖߂�l %RET%
    echo.
    echo S3�o�P�b�g�̗����̗L�����Ɏ��s���܂����B�ȉ����̗��R���l�����܂��B
    echo �E�������s�����Ă���
    echo.
    goto end
)
echo %BACKET_NAME%�̗�����L�������܂����B
echo.

:end
