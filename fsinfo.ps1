 #Grabbing a file to check which partition it is in.
 $path = $(Get-ChildItem -Path $args[0] | Select-Object -first 1).FullName
 $drive = $($(Get-ChildItem -Path $path | Select-Object -first 1).FullName).SubString(0,1)

 #Counting files
 $amountFiles = $(Get-ChildItem -Path $args[0] -Recurse | Measure-Object).Count

 $totalSize = 0
 #used for biggest size
 $biggest = 0
 $i = 0
 #true when previous object was current biggest file
 $nextIsBiggest = $false

 #looping through all files found, but with 2 stages. first with its file size, then its path name
 foreach($currentObject in Get-ChildItem -Path "." -Recurse | ForEach-Object {$_.Length, $_.FullName})
 {
 #if 'currentObject' is file size
 if($i % 2 -eq 0)
    {
        $totalSize += $currentObject
        if($currentObject -gt $biggest)
        {
        $biggest = $currentObject
        $nextIsBiggest = $true
        }
    } else # else it is file path
    {
        if($nextIsBiggest -eq $true)
        {
         #is the biggest file's path
         $biggestPath = $currentObject
         $nextIsBiggest = $false
        }
    }
    $i += 1
 }
 #calculate average
 $averageSize = $totalSize / $amountFiles

 #output
 Write-Output("Denne partisjonen er $($($($(Get-PSDrive $drive).Used)*100) / $($(Get-PSDrive $drive).Free + $(Get-PSDrive $drive).Used))% full.")
 Write-Output("Det finnes $amountFiles filer.")
 Write-Output("Den største er $biggestPath som er $($biggest/1KB) KB stor.")
 Write-Output("Gjennomsnittlig filstørrelse er $($averageSize/1KB) KB.")