# Folder Organiser
# 
# Description:
#
# A PowerShell Script which organises a folder of files and folders by creating a folder structure based on the creation date time of each file.
# User specifies a log directory which stores the log file, a source directory for the script to pickup the files, and a destination directory
# to MOVE the files to their new location
#
# Version History:
#
# V1 - Initial Release - 09/05/2022
#
#

#validPath - The function that checks to see if a given path is empty or a valid path
function validPath{
   
    Param (
         [string]$path,
         [string]$pathType
                )
        if($path -eq "")
        {
            Write-Warning "No path has been specified"
            return $false   
            }
    
        #Test if it's a UNC path, as UNC paths return false without the "FileSystem::" prefix
        $isUNCPath = [bool]([System.Uri]$path).isUnc
        if($isUNCPath -eq $true)
        {
            $path = "FileSystem::" + $path
            }

        if(!(Test-Path -Path $path -PathType $pathType))
        {           
            
                if($pathType -eq "Container")
                {
                    Write-Warning "Path does not exist"
                        }

                return $false
            }
            return $true
}

#extensionProvided - The function to check if a file extension has been provided
function extensionProvided{

    Param([string] $extension)

    if($extension -eq "")
    {
        Write-Warning "No extension provided"
        return $false
        }

        return $true

}

#moveFiles - The function that deals with moving items from one folder to another
function moveFiles{
      
    $logFileString = "Please enter log file save location"
    $sourceFolderString = "Please enter the SOURCE location of your files" 
    $destinationFolderString = "Please enter the DESTINATION of your files"
    $extensionString = "Please enter the extension you wish to filter by. Leave blank for all"
    $extensionResponseString = "Leaving the extension blank will move EVERY file in the directory which may consume large amounts of memory or take a long time to process, do you want to add an extension(Y/N)?"
    $container = "Container"
    $leaf = "Leaf"
    
    #Validate the folder locations specified by the user
    #If path is invalid ask user to to re-enter input and re-check

    $logFileLocation = Read-Host $logFileString
    $isValidLogPath = validPath $logFileLocation $container
    while($isValidLogPath -eq $false)
    {
        $logFileLocation = Read-Host $logFileString
        $isValidLogPath = validPath $logFileLocation $container
        }

    Start-Transcript -out $logFileLocation -Append

    $sourceFolder = Read-Host $sourceFolderString
    $isValidSourcePath = validPath $sourceFolder $container
    while($isValidSourcePath -eq $false)
    {
        $sourceFolder = Read-Host $sourceFolderString
        $isValidSourcePath = validPath $sourceFolder $container
        }

     $destinationFolder = Read-Host $destinationFolderString
    $isValidDestinationPath = validPath $destinationFolder $container
    while($isValidDestinationPath -eq $false)
    {
        $destinationFolder = Read-Host $destinationFolderString
        $isValidDestinationPath = validPath $destinationFolder $container
        }


    #Ask user for file extension. If no extension provided, double check with user this is correct.
    #This is to prevent someone accidently moving ALL files when they actually want to move a certain type
    $extension = Read-Host $extensionString
    $userProvidedExtension = extensionProvided $extension

    while($userProvidedExtension -eq $false)
    {
        $extensionResponse = Read-Host $extensionResponseString
    
        while($extensionResponse -ne "Y" -and $extensionResponse -ne "N")
         {
             $extensionResponse = Read-Host $extensionResponseString
         }

        if($extensionResponse -eq "Y")
        {
            $extension = Read-Host $extensionString
            $userProvidedExtension = extensionProvided $extension 
            }
        elseif($extensionResponse -eq "N")
        {
            $userProvidedExtension = $true
            }  

      }


    #Set the extension string value to either anything (*.*) or the extension (*.txt) based on user response
    if($extension -eq "")
    {
        $extension = "*.*"
        }
        else
        {
            $extension = "*." + $extension
            }
            
    Write-Host "Depending on the amount of files in the source folder, this process may take a considerable amount of time" -ForegroundColor Yellow

    #Loop through all files/folders in the directory and move them to the specified folder
    Get-ChildItem $sourceFolder -Filter $extension | Foreach-Object {

        $destination = $destinationFolder + 
            "\" + 
            "Processed" + 
            "\" +
            $_.CreationTime.Year + 
            "\" + 
            $_.CreationTime.Month + 
            "\" + 
            $_.CreationTime.Day

        $destinationFolderExists = validPath $destination $container
        if($destinationFolderExists -eq $false)
        {
                Write-Host "Creating new directory: $destination"
                New-Item -Path $destination -ItemType Directory
             }
                     

         #Check if object is a folder or file, then check if file already exists in destination
         $isDirectory = (get-item $_.FullName).PSIsContainer
         $destinationFilePath = $destination + "\" + $_.Name
         if($isDirectory -eq $true)
         {
            $fileExists = validPath $destinationFilePath $container
            }
            else
            {
                $fileExists = validPath $destinationFilePath $leaf
                }

         if($fileExists -eq $true)

            {
                Write-Warning "File already exists, renaming file $_ to avoid overwriting"
                $fileLocation = $sourceFolder + 
                    "\" + 
                    $_.Name

                $newFileName = $_.BaseName + 
                    "_" + 
                    $_.CreationTime.Year +
                    $_.CreationTime.Month +
                    $_.CreationTime.Day +
                    $_.CreationTime.Hour + 
                    $_.CreationTime.Minute + 
                    $_.CreationTime.Second + 
                    $_.CreationTime.Millisecond + 
                    $_.Extension

                Rename-Item -Path $fileLocation -NewName $newFileName
            
                $newFilePathDestination = $sourceFolder + "\" + $newFileName
                Move-Item $newFilePathDestination -Destination $destination

                Write-Information $newFileName "Processed"
            }
            else
            {
                Move-Item $_.FullName -Destination $destination
                Write-Information $_.Name "Processed"
            }
    }

    Write-Host "Files have been processed. Script now ending"
    Stop-Transcript

}

#Call moveFiles function to kick off the process
try{

    moveFiles

}
catch
{
    Write-Host $PSItem.Exception.Message -ForegroundColor RED
    Write-Host $_.ScriptStackTrace

    }