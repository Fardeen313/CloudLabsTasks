function Compare-LabCSV {

param(
    [string]$UserFile,
    [string]$AnswerFile,
    [string]$Lab
)

$user = Import-Csv $UserFile
$ans  = Import-Csv $AnswerFile

if ($user.Count -ne $ans.Count) {
    Write-Output "FAIL: Row count mismatch"
    return
}

switch ($Lab) {

"S1" {

$user = $user | Sort-Object SalesYear
$ans  = $ans  | Sort-Object SalesYear

for ($i=0;$i -lt $ans.Count;$i++){

if ($user[$i].SalesYear -ne $ans[$i].SalesYear){
Write-Output "FAIL: Year mismatch"
return
}

if ([math]::Round($user[$i].TotalSales,2) -ne [math]::Round($ans[$i].TotalSales,2)){
Write-Output "FAIL: TotalSales mismatch"
return
}

}

Write-Output "PASS"

}

"S2" {

$user = $user | Sort-Object Department
$ans  = $ans  | Sort-Object Department

for ($i=0;$i -lt $ans.Count;$i++){

if ($user[$i].Department -ne $ans[$i].Department){
Write-Output "FAIL: Department mismatch"
return
}

if ($user[$i].Name -ne $ans[$i].Name){
Write-Output "FAIL: Wrong employee"
return
}

}

Write-Output "PASS"

}

"S3" {

$user = $user | Sort-Object Region
$ans  = $ans  | Sort-Object Region

for ($i=0;$i -lt $ans.Count;$i++){

if ($user[$i].Region -ne $ans[$i].Region){
Write-Output "FAIL: Region mismatch"
return
}

if ([math]::Round($user[$i].TotalSales,2) -ne [math]::Round($ans[$i].TotalSales,2)){
Write-Output "FAIL: Total mismatch"
return
}

}

Write-Output "PASS"

}

}

}