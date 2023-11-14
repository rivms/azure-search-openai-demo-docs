# ./scripts/loadenv.ps1

# Load .env file

if (Test-Path -Path ".env") {
  Write-Host "Loading .env file"
  Get-Content .\.env | ForEach-Object {
    $key, $value = $_ -split '=', 2
    [Environment]::SetEnvironmentVariable($key, $value, 'Process')
    Write-Host "Loaded key: $key"
  }
} else {
  Write-Host ".env file not found"
  exit
}


$pythonPath = $(Get-Command python).Source

Write-Host "'Installing dependencies from 'requirements.txt' using executable $pythonPath"

Start-Process -FilePath $pythonPath -ArgumentList "-m pip install -r ./scripts/requirements.txt" -Wait -NoNewWindow

Write-Host 'Running "prepdocs.py"'
$cwd = (Get-Location)

# Optional Data Lake Storage Gen2 args if using sample data for login and access control
if ($env:AZURE_ADLS_GEN2_STORAGE_ACCOUNT) {
  $adlsGen2StorageAccountArg = "--datalakestorageaccount $env:AZURE_ADLS_GEN2_STORAGE_ACCOUNT"
  $adlsGen2FilesystemPathArg = ""
  if ($env:AZURE_ADLS_GEN2_FILESYSTEM_PATH) {
    $adlsGen2FilesystemPathArg = "--datalakefilesystempath $env:ADLS_GEN2_FILESYSTEM_PATH"
  }
  $adlsGen2FilesystemArg = ""
  if ($env:AZURE_ADLS_GEN2_FILESYSTEM) {
    $adlsGen2FilesystemArg = "--datalakefilesystem $env:ADLS_GEN2_FILESYSTEM"
  }
  $aclArg = "--useacls"
}
# Optional Search Analyzer name if using a custom analyzer
if ($env:AZURE_SEARCH_ANALYZER_NAME) {
  $searchAnalyzerNameArg = "--searchanalyzername $env:AZURE_SEARCH_ANALYZER_NAME"
}
$argumentList = "./scripts/prepdocs.py `"$cwd/data/*.pdf`" $adlsGen2StorageAccountArg $adlsGen2FilesystemArg $adlsGen2FilesystemPathArg $searchAnalyzerNameArg " + `
"$aclArg --storageaccount $env:AZURE_STORAGE_ACCOUNT --container $env:AZURE_STORAGE_CONTAINER " + `
"--searchservice $env:AZURE_SEARCH_SERVICE --openaihost `"$env:OPENAI_HOST`" " + `
"--openaiservice `"$env:AZURE_OPENAI_SERVICE`" --openaikey `"$env:OPENAI_API_KEY`" " + `
"--openaiorg `"$env:OPENAI_ORGANIZATION`" --openaideployment `"$env:AZURE_OPENAI_EMB_DEPLOYMENT`" " + `
"--openaimodelname `"$env:AZURE_OPENAI_EMB_MODEL_NAME`" --index $env:AZURE_SEARCH_INDEX " + `
"--localpdfparser " + `
"--formrecognizerservice $env:AZURE_FORMRECOGNIZER_SERVICE --tenantid $env:AZURE_TENANT_ID -v"

Start-Process -FilePath $pythonPath -ArgumentList $argumentList -Wait -NoNewWindow
