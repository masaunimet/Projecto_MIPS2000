.macro print_string(%cadena)
li $v0 4
la $a0 %cadena
syscall
.end_macro

.macro salir
li $v0 10
syscall
.end_macro

.macro convertir_numero(%cadena)
li $t9 0
li $t2 0
loop:
	
	lb $t1 %cadena($t9)
	
	beqz $t1 fin_loop
	beq $t1 0x0A llenar_ceros
	
	bgt $t9 50 inicio
	blt $t1 0x30 inicio
	bgt $t1 0x39 inicio
 
	addi $t2 $t2 1
	addi $t9 $t9 1
	
	b loop
	
	llenar_ceros: 
		 
		 beq $t9 50 llenar_ceros_part2
		 li $t1 0x30 
		 sb $t1 %cadena($t9)
		  
		 addi $t9 $t9 1 
		 b llenar_ceros
		 
	llenar_ceros_part2:
	
	li $t9 49
	subi $t2 $t2 1
		
	loop_ceros:
		
		bltz $t2 fin_loop
		
		lb $t1 %cadena($t2)
		sb $s0 %cadena($t2)
		sb $t1 %cadena($t9)
			
		subi $t9 $t9 1
		subi $t2 $t2 1
		
		b loop_ceros
		
fin_loop:
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

li $s0 0x30

beq $t0 1 sumar
beq $t0 2 restar
beq $t0 3 multiplicar

sumar:

convertir_numero(espacionumero1)
convertir_numero(espacionumero2)

print_string(espacionumero1)
print_string(salto)
print_string(espacionumero2)	

salir

restar:

multiplicar:

salir:
salir

