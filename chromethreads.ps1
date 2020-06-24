#I assumed as few lines as possible meant somewthing like this. getting the process, looping though all and printing out info + counting threads.
Write-Output("Jeg er en test")
Get-Process chrome | ForEach-Object {Write-Output("$($_.name) $($_.id) $($($($_.Threads)).Count)")}
