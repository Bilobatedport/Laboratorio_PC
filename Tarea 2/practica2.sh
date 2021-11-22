
# ESCANEO DE PUERTOS ACTIVOS EN LA RED Y AGREGO MENÚ CON UN WHILE
while($true){



    Write-Output ""

    
    Write-Output "Option 1: Escaneo de subred"                           
    Write-Output "Option 2: Escaneo de puertos para equipo"
    Write-Output "Option 3: Escaneo de puertos para todos los equipos activos en red"                            


    Write-Output ""
    
    
    [string]$option = Read-Host -Prompt "Opcion"

    
    
    #  ESCANEO DE SUBRED
    #  DEFINIMOS EL USO DE LA OPCION DEL MENU CON UN IF PARA REALIZAR NUESTRAS ACCIONES
    if ($option -eq "1"){


    #DETERMINAMOS NUESTRO GATEWAY
    $subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
    $manyips = $subnet.Length

    if($manyips -eq 1){$subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop[1]}
   
    
    
    $subnetrange = $subnet.Substring(0,$subnet.IndexOf('.') + 1 + $subnet.Substring($subnet.IndexOf('.') + 1).IndexOf('.') + 3)

    $isdot = $subnetrange.EndsWith('.')

    if ($isdot -like "False"){$subnetrange = $subnetrange + '.'}
# DEFINIMOS NUESTRA VARIABLE DEL RANGO DE LA SUBRED
$iprange = @(1..254)

#MENSAJE DE CONFIRMACIÓN QUE SE ESTA ESCANEANDO
Write-Output ""
Write-Output "Red actual: $subnet"
Write-Output ""
Write-Output "Escaneando........"
Write-Output ""

foreach ($i in $iprange){

# AQUI HACEMOS EL TEST DE CONEXION A LA IP PARA RESOLVER EL DNS 
$currentip = $subnetrange + $i

$islive = test-connection $currentip -Quiet -Count 1

if ($islive -eq "True"){

try{$dnstest = (Resolve-DnsName $currentip -ErrorAction SilentlyContinue).NameHost}catch{}

if ($dnstest -like "*.home") {

$dnstest = $dnstest -replace ".home",""

}
# IMPRIMIMOS LOS PUERTOS CON ACCESO
Write-Output ""
Write-Output "Puertos con acesso: $currentIP | DNS: $dnstest"


 # ESCANEO DE PUERTOS
 # PONEMOS LOS PUERTOS CON LOS QUE VERIFICAREMOS SI ESTAN ABIERTOS
    $portstoscan = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
    $waittime = 100
 # GENERAMOS UN BUCLE DE FOREACH PARA PODER EVALUAR CADA PUERTO
    foreach ($p in $portstoscan){

    $TCPObject = new-Object system.Net.Sockets.TcpClient
    try{$result = $TCPObject.ConnectAsync($currentip,$p).Wait($waittime)}catch{}
# IMPRIMIMOS CADA PUERTO ABIERTO SI EL PUERTO ESTA ABIERTO SE TOMARA COMO TRUE Y IMPRIMIRA QUE ESTA ABIERTO TAL PUERTO
    if ($result -eq "True"){
    
        Write-Host "Puerto abierto: " -NoNewline; Write-Host $p -ForegroundColor Green
    }

    }
}
}

    
    }

       # ESCANEAR RED

    if ($option -eq "2"){

    
       
    # ESTABLECER VARIABLES Y MATRICES

    $ScanAll = ""
    
    $waittime = 400
    $liveports = @()
   
    $destip = @() 
          
    $Portarray = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)

    

    # OBTENER LOS DETALLES DEL USUARIO

    
    Write-Output ""

    # OBTENER LOS TARGETS
    
    Write-Output "Introduzca una dirección IP, una URL o una ruta de archivo (ejemplo: C:\Temp\IPList.txt)....."
    
    [string]$Typeofscan = Read-Host -Prompt "Target"
  

    if ($Typeofscan -like "*txt") {
    
    $PulledIPs = Get-Content $Typeofscan
    
    foreach ($i in $PulledIPs) {

    # LLENAR LA MATRIZ DE DESTINO CON TODAS LAS IP
    
    $destip += $i
    
    } # PARA CADA UNO DEL DESTINO LAS ASIGNAMOS

    }

    else {
    
    # ESCANEO UNICO

    $destip = $Typeofscan
    
    }


    # OBTENEMOS LOS PUERTOS
    Write-Output "`n"
    Write-Output "Opción 1: | ESCANEO COMÚN | Opción 2: ESCANEO COMPLETO (1-65535) | Opciones 3: ESCANEO RAPIDO (menos preciso)"
    Write-Output "--------------------------------------------------------------------------------------------------"

    $ScanPorts = Read-Host -Prompt "NUMERO DE OPCIÓN" 

    if ($ScanPorts -eq 1) {$ScanAll = ""}
    if ($ScanPorts -eq 2) {$ScanAll = "True"}
    if ($ScanPorts -eq 3) {$ScanAll = "Quick"}
    if ($ScanPorts -ne 1 -AND $ScanPorts -ne 2 -AND $ScanPorts -ne 3){exit}



  # OBTENEMOS LOS PORTARRAY

 
    if ($ScanAll -eq "True") {

    $waittime = 400
    $Portarray = 1..65535 
    
    }

    if ($ScanAll -eq "Quick") {

    $waittime = 40
    $Portarray = 1..65535

    }

    else {
    
    # PORTARRAY SIGUE SIENDO EL MISMO (Puertos comunes)

    }



    # ESCANEAMOS

    
    Write-Output ""
    Write-Output "INICIANDO ESCANEO....."
    
    # ESCANEAR CADA DEST
    foreach ($i in $destip){



    foreach ($p in $Portarray){


    $TCPObject = new-Object system.Net.Sockets.TcpClient

    $Result = $TCPObject.ConnectAsync($i,$p).Wait($waittime)


    if ($Result -eq "True") {
    
    $liveports += $p  

    }


    } # AGREGAMOS PARA CADA UNO DE LOS ARREGLOS

    # MOSTRAMOS LOS PUERTOS CONOCIDOS


    $Knownservices = @()
    
    $ftp = "Port: 20,21     Service: FTP"
    $http = "Port: 80     Service: HTTP"
    $https = "Port: 443     Service: HTTPS"
    $ssh = "Port: 22     Service: SSH"
    $telnet = "Port: 23     Service: Telnet"
    $smtp = "Port: 25     Service: SMTP"
    $ipsec = "Port: 50,51     Service: IPSec"
    $dns = "Port: 53     Service: DNS"
    $pop3 = "Port: 110     Service: POP3"
    $netbios = "Port: 135-139     Service: NetBIOS"
    $imap4 = "Port: 143     Service: IMAP4"
    $snmp = "Port: 161,162     Service: SNMP"
    $ldap = "Port: 389     Service: LDAP"
    $smb = "Port: 445     Service: SMB"
    $ldaps = "Port: 636     Service: LDAPS"
    $rpc = "Port: 1025     Service: Microsoft RPC"
    $sql = "Port: 1433     Service: SQL"
    $rdp = "Port: 3389     Service: RDP"
    $winrm = "Port: 5985,5986     Service: WinRM"
    $proxy = "Port: 8080     Service: HTTP Proxy"
    $webmin = "Port: 10000     Service: Webmin"
        

    if ($liveports -contains "20" -or $liveports -contains "21"){$knownservices += $ftp}
    if ($liveports -contains "22"){$knownservices += $ssh}
    if ($liveports -contains "23"){$knownservices += $telnet}
    if ($liveports -contains "50" -or $liveports -contains "51"){$knownservices += $ipsec}
    if ($liveports -contains "53"){$knownservices += $dns}
    if ($liveports -contains "80"){$knownservices += $http}
    if ($liveports -contains "110"){$knownservices += $pop3}
    if ($liveports -contains "135" -or $liveports -contains "136" -or $liveports -contains "137" -or $liveports -contains "138" -or $liveports -contains "139"){$knownservices += $netbios}
    if ($liveports -contains "143"){$knownservices += $IMAP4}
    if ($liveports -contains "161"-or $liveports -contains "162"){$knownservices += $snmp}
    if ($liveports -contains "389"){$knownservices += $ldap}
    if ($liveports -contains "443"){$knownservices += $https}
    if ($liveports -contains "445"){$knownservices += $smb}
    if ($liveports -contains "636"){$knownservices += $ldaps}
    if ($liveports -contains "1025"){$knownservices += $rpc}
    if ($liveports -contains "1433"){$knownservices += $sql}
    if ($liveports -contains "3389"){$knownservices += $rdp}
    if ($liveports -contains "5985" -or $liveports -contains "5986"){$knownservices += $winrm}
    if ($liveports -contains "8080"){$knownservices += $proxy}
    if ($liveports -contains "10000"){$knownservices += $webmin}
    
    # DEFINIMOS ESTO PARA LA SALIDA DE NUESTROS RESULTADOS
    
    Write-Output "--------------------------------------------------------------------------------------------------"
    Write-Output ""
    Write-Output "Target: $i "-NoNewline; Write-Host $i -ForegroundColor Green
    Write-Output ""
    Write-Output "PUERTOS ENCONTRADOS: "
    Write-Output ""
    Write-Output $liveports
    Write-Output ""
    Write-Output ""
    Write-Output "SERVICIOS CONOCIDOS:"
    Write-Output ""
    Write-Output $Knownservices
    Write-Output ""
    

    # BORRAMOS LA MATRIZ PARA EL SIGUIENTE
    $liveports = @()

    

    } # PARA CADA $i EN DestIP
    
    
    }
    }echo Hello World