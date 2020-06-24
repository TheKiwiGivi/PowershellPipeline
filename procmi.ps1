
Foreach ($currentId in $args)
{
    $currentProcess = $(Get-Process | Where-Object {$_.Id -eq $currentId})
    #getting virtual memory size
    $vm = $currentProcess.VirtualMemorySize
    $virtualMemorySize  = $vm/1MB

    #getting working set
    $ws = $currentProcess.WorkingSet
    $workingSetSize = $ws/1KB

    #creating filename by formatting Get-Date and getting id
    $filename = "$($currentId)--$(Get-Date -UFormat "%Y%m%d-%H%M%S").meminfo"

   #storing everything in the newly created file
    "Informasjon om prosess $currentId `nTotalt bruk av virtuelt minne: $virtualMemorySize MB `nStorrelse pa Working Set: $workingSetSize KB`n" > $filename
}