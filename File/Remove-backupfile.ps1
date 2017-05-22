function Remove-backupfile {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Path to the folder to check for old files
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [string]$path,

        # Age of days to delete
        [int]$age
    )

    Begin {
        $checkdate = (get-date).AddDays( - $age)
    }
    Process {
        # Delete files older than the $limit.
        write-verbose -Message "Starting to check the given path $path"
        Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $checkdate } | Remove-Item -Force
        # Delete any empty directories left behind after deleting the old files.
        Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
    }
    End {
    }
}
