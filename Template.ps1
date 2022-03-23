$saved_dir = [ordered]@{flexplayer="~\dir_to\flexplayer";passkeeper="~\dir_to\passkeeper";}

Import-Module oh-my-posh
Set-PoshPrompt -Theme m365princess
Import-Module -Name Terminal-Icons
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

###############################################################
#                          FUNCTIONS                          #
###############################################################

function varNameCheck {
    param (
        [Parameter(Mandatory=$true)]
        # String to be validated
        [String]$Name
    )
    process {
        # check all to lower case
        $Name = $Name.ToLower()
        return $Name -match "^[A-Za-z][A-Za-z0-9_]{3,30}$"
    }
<#
.DESCRIPTION
Validates given string under regex /^[A-Za-z][A-Za-z0-9_]{3,30}$ : Return Boolean
#>
}

function flexplayer {
    # Get-Location, equivalent of 'pwd' / '$pwd'
    $curr = Get-Location
    Set-Location $saved_dir.key_1
    # Python Entry file
    py ./Player.py
    # Return user to their last Working Directory
    Set-Location $curr
}

# Launch passkeeper
function passkeeper {
    $curr = Get-Location
    Set-Location $saved_dir.key_2
    # Python Entry file
    py .\PassKeeperCommandLine.py
    Set-Location $curr
}

function apkinstall { 
    param (
        [Parameter(Mandatory=$true)]
        $apkfile
    )
    process {
        adb install -t $apkfile
    }
<#
.DESCRIPTION

Requires proper installation of adb

#>
}

function go{
    # Go to one of the saved locations in $saved_dir
    param (
        [Parameter(Mandatory=$true)]
        [String]$keyName
    )
    process {
        $keyName = $keyName.ToLower()
        if (!varNameCheck($keyName)) {
            return Write-Error "Invalid Dir Key"
        }
        Set-Location $saved_dir.$keyName
    }
}


###############################################################
#                            ALIAS                            #
###############################################################

# https://github.com/iamfoyez/FlexPlayer
Set-Alias -Name fp -Value flexplayer

Set-Alias -Name opendir -Value explorer
# Usage: Launches a given directory in File Explorer
# PS> opendir $saved_dir.Flexplayer

