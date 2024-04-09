$continue = $true
while($continue)
{

    if ([console]::KeyAvailable)
    {
        # echo "Toggle with F12";
        $x = [System.Console]::ReadKey();
        $enter_key = $x.keyChar;
        # echo $x;
        Write-Host "";
        Write-Host "Target has pressed $enter_key key";
        switch ( $x.key)
        {
            F12 { $continue = $false }
        }
    } 
    # else
    # {
    #     $wsh = New-Object -ComObject WScript.Shell
    #     $wsh.SendKeys('{CAPSLOCK}')
    #     sleep 1
    #     [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wsh)| out-null
    #     Remove-Variable wsh
    # }    
}