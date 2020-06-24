#meny
$menyvalg = "1 - Hvem er jeg og hva er navnet på dette scriptet?
2 - Hvor lenge er det siden siste boot?
3 - Hvor mange prosesser og trader finnes?
4 - Hvor mange context switch'er fant sted siste sekund?
5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
6 - Hvor mange interrupts fant sted siste sekund?
9 - Avslutt dette scriptet"

#used for user response
$answer = 0

while($answer -ne '9'){
Clear-Host
Write-Output($menyvalg)
#reading intput
$answer = Read-Host -Prompt 'Command'
switch ( $answer )
{
    1  { $user = $env:UserName
         $script = $MyInvocation.MyCommand.Name
         $result = "Jeg er $user og navnet pa dette scriptet er $script" }

    2 { $lastBootTime = $(Get-CimInstance -ClassName win32_operatingsystem).LastBootUpTime
        $result = "Siste boot var: $lastBootTime" }

        #denne er veldig treg første gang den kjøres av en eller annen grunn (ca. 15sec)
    3  { $processAmount = $(Get-Process | Measure-Object ).Count
    #alt: $(Get-CimInstance Win32_PerfFormattedData_PerfOS_System).Processes
           #$amount = $(Get-Process | ForEach-Object {Write-Output((Get-Process $_.Name |Select-Object -ExpandProperty Threads).Count)} | Measure-Object -Sum).Sum
           $amount = $(Get-CimInstance Win32_PerfFormattedData_PerfOS_System).Threads
        $result = "Det finnes $processAmount prosesser og det finnes $amount trader." }

        #gets context switches
    4 { $switches = $(Get-CimInstance Win32_PerfFormattedData_PerfOS_System).ContextSwitchesPersec
        $result = "$switches context switches fant sted siste sekund." }

        #getting processortime
    5  { $oldKernelTime = $($(Get-Process).PrivilegedProcessorTime.TotalSeconds | Measure-Object -Sum).Sum
         $oldUserTime = $($(Get-Process).UserProcessorTime.TotalSeconds | Measure-Object -Sum).Sum

         Start-Sleep -Seconds 1

         $newKernelTime = $($(Get-Process).PrivilegedProcessorTime.TotalSeconds | Measure-Object -Sum).Sum
         $newUserTime = $($(Get-Process).UserProcessorTime.TotalSeconds | Measure-Object -Sum).Sum

         #adding total
         $totalKernelTime = $newKernelTime - $oldKernelTime
         $totalUserTime = $newUserTime - $oldUserTime
        $result = "Andel kernelmode: $totalKerneltime%. Andel usermode: $totalUserTime%." }

        #gets interrupts per sec
    6 { $interrupts = $($(Get-CimInstance Win32_PerfFormattedData_Counters_ProcessorInformation) | Where-Object {$_.Name -eq "_total"}).InterruptsPersec
       $result = "$interrupts interrupts fant sted siste sekund." }

    9  { Write-Output("Exiting..")
        return }
}


Write-Output($result)
$answer = Read-Host
}
Write-Output("Exiting..")