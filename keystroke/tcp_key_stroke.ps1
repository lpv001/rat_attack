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

while($True)
{

    if ([console]::KeyAvailable)
    {
        $x = [System.Console]::ReadKey();
        $enter_key = $x.keyChar;
        sendKeyStroke $socket $enter_key;
    } 

}


