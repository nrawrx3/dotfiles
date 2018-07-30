function Set-VsCmd
{
    $targetDir = "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build"
    echo $targetDir
    pushd $targetDir
    cmd /c "vcvarsall.bat x64&set" |
    foreach {
      if ($_ -match "(.*?)=(.*)") {
        Set-Item -force -path "ENV:\$($matches[1])" -value "$($matches[2])"
      }
    }
    popd
    write-host "`nVisual Studio $version Command Prompt variables set." -ForegroundColor Yellow
}
