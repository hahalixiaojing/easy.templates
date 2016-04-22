param($ProjectDemo,$NewProjectName)

if($ProjectDemo -ne "owin"){
    write "项目模板不存在";
    return;
}
if([System.String]::IsNullOrWhiteSpace($NewProjectName)){
    write "没有输入新项目名称";    
    return;
}

cd projects;
New-Item -ItemType Directory -Name $NewProjectName;
cd ..
Copy-Item -Path .\base\owin\ETao.Menu\* -Destination .\projects\$NewProjectName -Recurse; 

cd projects\$NewProjectName;

$location = Get-Location;

$files = [System.IO.Directory]::GetFiles($location.ToString(),"*.cs",[System.IO.SearchOption]::AllDirectories);
foreach($file in $files)
{
    $content = Get-Content $file;
    $content = $content.Replace("ETao.Menu",$NewProjectName); 
    Set-Content -Path $file $content;
}

$csprojfiles = [System.IO.Directory]::GetFiles($location,"*.csproj",[System.IO.SearchOption]::AllDirectories);
foreach($file in $csprojfiles)
{
    $content = Get-Content $file;
    $content = $content.Replace("ETao.Menu",$NewProjectName); 
    Set-Content -Path $file $content;
}

$directories = [System.IO.Directory]::GetDirectories($location,"ETao.Menu*");
foreach($dir in $directories)
{
    $newdir = $dir.Replace("ETao.Menu",$NewProjectName);

    write $newdir;
    write $dir;
    [System.IO.Directory]::Move($dir,$newdir);
}
$csprojfiles = [System.IO.Directory]::GetFiles($location,"ETao.Menu*.csproj",[System.IO.SearchOption]::AllDirectories);
foreach($file in $csprojfiles)
{
    $newfile = $file.Replace("ETao.Menu",$NewProjectName);
    [System.IO.File]::Move($file,$newfile);
}

$sln = [System.IO.Directory]::GetFiles($location,"ETao.Menu.sln")[0];
$content = Get-Content $sln;
$content = $content.Replace("ETao.Menu",$NewProjectName);
Set-Content -Path $sln $content;

$newsln = $sln.Replace("ETao.Menu",$NewProjectName);
[System.IO.File]::Move($sln,$newsln);

cd ..\..\

write "创建完毕";