Write-Host "Num Args:" $args.Length;
foreach ($arg in $args)
{
  Write-Host "Arg: $arg";
  date > C:\tmp\potest.txt
}