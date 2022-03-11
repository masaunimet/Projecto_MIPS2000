.macro print_string(%cadena)
li $v0 4
la $a0 %cadena
syscall
.end_macro

.macro salir
li $v0 10
syscall
.end_macro

.data
mensaje: .asciiz "Ingrese operacion a realizar \n1. Sumar\n2. Restar\n3. Multiplicar\n4. Salir\n"
salto: .asciiz "\n"
mensajeerror : .asciiz "ingrese una opcion del 1 al 4"
primernumero: .asciiz "Ingrese el primer numero: "
segundonumero: .asciiz "Ingrese el segundo numero: "
resultado: .asciiz "El resultado es"
espacionumero1: .space 401
espacionumero2: .space 401
espacionumero3: .space 401

.text

#.eqv $t1 digito_cadena_1
#.eqv $t2 digito_cadena_2
#.eqv $t3 digito_cadena_3
#.eqv $t4 limite_cadena_1
#.eqv $t5 limite_cadena_2

inicio:
print_string(mensajeerror)
print_string(salto)
print_string(mensaje)

li $v0 5
syscall
move $t0 $v0

blt $t0 1 inicio
bgt $t0 4 inicio
beq $t0 4 salir

print_string(salto)
print_string(primernumero)

li $v0 8
la $a0 espacionumero1
li $a1 401
syscall

print_string(salto)
print_string(segundonumero)
li $v0 8
la $a0 espacionumero2
li $a1 401
syscall

beq $t0 1 sumar
beq $t0 2 restar
beq $t0 3 multiplicar




sumar:

li $t9 0
loop1:
	
	lb $t1 espacionumero1($t9)
	
	beqz $t1 fin_loop1
	beq $t1 0x0A llenar_ceros #
	
	
	
	beq $t9 50 inicio
	blt $t1 0x30 inicio
	bgt $t1 0x39 inicio
 
	addi $t4 $t4 1
	addi $t9 $t9 1
	
	b loop1
	
	llenar_ceros: 
		 
		 beq $t9 50 fin_loop1
		 li $t1 0x30 
		 sb $t1 espacionumero1($t9)
		  
		 addi $t9 $t9 1 
		 b llenar_ceros
		
fin_loop1:

li $t9 0
print_string(mensaje)

loop2:
	
	lb $t2 espacionumero2($t9)
	
	beqz $t2 fin_loop2
	beq $t2 0x0A llenar_ceros2
	
	beq $t9 50 inicio
	blt $t2 0x30 inicio
	bgt $t2 0x39 inicio
 
	addi $t5 $t5 1
	addi $t9 $t9 1
	
	b loop2
	
	llenar_ceros2: 
		 
		 beq $t9 50 fin_loop2
		 li $t2 0x30 
		 sb $t2 espacionumero2($t9)
		  
		 addi $t9 $t9 1 
		 b llenar_ceros2
	
fin_loop2:

print_string(espacionumero2)
print_string(espacionumero1)

li $t9 0

loop_ceros:
	


	

salir

restar:

multiplicar:

salir:
salir

