# This script builds a Cura release using the cura-build-environment Windows docker image.
Param (
  # Docker parameters
  [string]$DockerImage = "stereotech/ste-slicer-build-environment:stable",
  # Branch parameters
  [string]$CuraBranchOrTag = "master",
  [string]$UraniumBranchOrTag = "master",
  [string]$CuraEngineBranchOrTag = "master",
  [string]$CuraBinaryDataBranchOrTag = "master",
  [string]$FdmMaterialsBranchOrTag = "master",
  [string]$CharonBranchOrTag = "master",
  # Cura release parameters
  [Parameter(Mandatory = $true)]
  [Int32]$CuraVersionMajor,
  [Parameter(Mandatory = $true)]
  [Int32]$CuraVersionMinor,
  [Parameter(Mandatory = $true)]
  [Int32]$CuraVersionPatch,
  [Parameter(Mandatory = $false)]
  [AllowEmptyString()]
  [string]$CuraVersionExtra = "",
  [Parameter(Mandatory = $false)]
  [string]$CuraBuildName = "win",
  [Parameter(Mandatory = $false)]
  [string]$CuraCloudApiRoot = "https://api.ultimaker.com",
  [Parameter(Mandatory = $false)]
  [Int32][ValidatePattern("[0-9]+")]$CuraCloudApiVersion = 0,
  [Parameter(Mandatory = $false)]
  [string]$CuraCloudAccountApiRoot = "https://account.ultimaker.com",
  [Parameter(Mandatory = $false)]
  [string]$CuraWindowsInstallerType = "EXE"
)

$outputDirName = "windows-installers"

New-Item $outputDirName -ItemType "directory" -Force
$repoRoot = Join-Path $PSScriptRoot -ChildPath "..\.." -Resolve
$outputRoot = Join-Path (Get-Location).Path -ChildPath $outputDirName -Resolve

if ($CuraWindowsInstallerType = "EXE") {
  $CPACK_GENERATOR = "NSIS"
}
elseif ($CuraWindowsInstallerType = "MSI") {
  $CPACK_GENERATOR = "WIX"
}
else {
  Write-Error `
    -Message "Invalid value [$CuraWindowsInstallerType] for CuraWindowsInstallerType. Must be EXE or MSI" `
    -Category InvalidArgument
  exit 1
}

& winpty docker.exe run -it --rm `
  --volume ${repoRoot}:C:\cura-build-src `
  --volume ${outputRoot}:C:\cura-build-output `
  --env CURA_BUILD_SRC_PATH=C:\cura-build-src `
  --env CURA_BUILD_OUTPUT_PATH=C:\cura-build-output `
  --env CURA_BRANCH_OR_TAG=$CuraBranchOrTag `
  --env URANIUM_BRANCH_OR_TAG=$UraniumBranchOrTag `
  --env CURAENGINE_BRANCH_OR_TAG=$CuraEngineBranchOrTag `
  --env CURABINARYDATA_BRANCH_OR_TAG=$CuraBinaryDataBranchOrTag `
  --env FDMMATERIALS_BRANCH_OR_TAG=$FdmMaterialsBranchOrTag `
  --env CHARON_BRANCH_OR_TAG=$CharonBranchOrTag `
  --env CURA_VERSION_MAJOR=$CuraVersionMajor `
  --env CURA_VERSION_MINOR=$CuraVersionMinor `
  --env CURA_VERSION_PATCH=$CuraVersionPatch `
  --env CURA_VERSION_EXTRA=$CuraVersionExtra `
  --env CURA_BUILD_NAME=$CuraBuildName `
  --env CURA_CLOUD_API_ROOT=$CuraCloudApiRoot `
  --env CURA_CLOUD_API_VERSION=$CuraCloudApiVersion `
  --env CURA_CLOUD_ACCOUNT_API_ROOT=$CuraCloudAccountApiRoot `
  --env CPACK_GENERATOR=$CPACK_GENERATOR `
  $DockerImage `
  powershell.exe -Command cmd /c "C:\cura-build-src\scripts\windows\build_in_docker_vs2015.cmd"
