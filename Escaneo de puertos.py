import nmap
scanner = nmap.PortScanner()
print("---------------------" * 4)
print("Ejemplo simple de automatizacion de Nmap [PortScanner]")
print("---------------------" * 4)

ip_addr = input("Favor Ingrese direccion IP a escanear: ")
print("La direccion IP ingresada corresponde a: ", ip_addr)
type(ip_addr)

resp_op = input("""\nFavor ingrese el tipo de escaner que desea ejecutar
                [1] Escaneo SYN ACK (semiabierto)
                [2] Escaneo UDP
                [3] Escaneo SYN Completo \n""")
print("Opción Ingresada: ", resp_op)

print("<< Version Nmap: ", scanner.nmap_version(), ">>>")

if resp_op == '1':
    print("---------------------" * 4)
    print("Favor espere, escaneando el host " + ip_addr)
    print("---------------------" * 4)
    scanner.scan(ip_addr, '1-1024', '-v -sS')
    print(scanner.scaninfo())
    print("Estado IP =>", scanner[ip_addr].state())
    print(scanner[ip_addr].all_protocols())
    print("Puertos Abiertos =>", scanner[ip_addr]['tcp'].keys())

elif resp_op == '2':
    print("---------------------" * 4)
    print("Favor espere, escaneando el host " + ip_addr)
    print("---------------------" * 4)
    scanner.scan(ip_addr, '1-1024', '-v -sU')
    print(scanner.scaninfo())
    print("Estado IP =>", scanner[ip_addr].state())
    print(scanner[ip_addr].all_protocols())
    print("Puertos Abiertos =>", scanner[ip_addr]['udp'].keys())

elif resp_op == '3':
    print("---------------------" * 4)
    print("Favor espere, escaneando el host " + ip_addr)
    print("---------------------" * 4)
    scanner.scan(ip_addr, '1-1024', '-v -sS -sV -sC -A -O')
    print(scanner.scaninfo())
    print("Estado IP =>", scanner[ip_addr].state())
    print(scanner[ip_addr].all_protocols())
    print("Puertos Abiertos =>", scanner[ip_addr]['tcp'].keys())

elif resp_op >= '4':
    print("¡¡¡ Favor ingrese opcion valida !!!")