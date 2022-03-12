.macro print_string(%cadena)
li $v0 4
la $a0 %cadena
syscall
.end_macro

.macro salir
li $v0 10
syscall
.end_macro

.macro llenar_ceros(%cadena)
li $t9 0x30
li $t8 0
loop_llenar:
	bgt $t8 49 fin_loop_llenar
	sb $t9 %cadena($t8)
	
	addi $t8 $t8 1
	b loop_llenar
	
fin_loop_llenar:
addi $t8 $t8 1
sb $zero %cadena($t8)
.end_macro

.macro llenar_ceros2(%cadena)
li $t9 0x30
li $t8 0
loop_llenar:
	bgt $t8 50 fin_loop_llenar2
	sb $t9 %cadena($t8)
	
	addi $t8 $t8 1
	b loop_llenar
	
fin_loop_llenar2:
addi $t8 $t8 1
sb $zero %cadena($t8)
.end_macro

.macro convertir_numero(%cadena)
li $t9 0
li $t8 0
loop:
	
	lb $t7 %cadena($t9)
	
	beqz $t7 fin_loop
	beq $t7 0x0A llenar_ceros
	
	bgt $t9 50 inicio
	blt $t7 0x30 inicio
	bgt $t7 0x39 inicio
 
	addi $t8 $t8 1
	addi $t9 $t9 1
	
	b loop
	
	llenar_ceros: 
		 
		 beq $t9 50 llenar_ceros_part2
		 li $t7 0x30 
		 sb $t7 %cadena($t9)
		  
		 addi $t9 $t9 1 
		 b llenar_ceros
		 
	llenar_ceros_part2:
	
	li $t9 49
	subi $t8 $t8 1
		
	loop_ceros:
		
		bltz $t8 fin_loop
		
		lb $t7 %cadena($t8)
		sb $s0 %cadena($t8)
		sb $t7 %cadena($t9)
			
		subi $t9 $t9 1
		subi $t8 $t8 1
		
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
espacionumero1: .space 51
espacionumero2: .space 51
espacionumero3: .space 52

.text

.eqv opcion $t0
.eqv digito1 $t1
.eqv digito23 $t2
.eqv boleano $t3 
.eqv indice $t4 
.eqv indice3 $t5

li $s0 0x30
li $s1 0x39

inicio:
llenar_ceros(espacionumero1)
llenar_ceros(espacionumero2)
llenar_ceros2(espacionumero3)
print_string(mensajeerror)
print_string(salto)
print_string(mensaje)

li $v0 5
syscall
move $t0 $v0

blt opcion 1 inicio
bgt opcion 4 inicio
beq opcion 4 salir

print_string(salto)
print_string(primernumero)

li $v0 8
la $a0 espacionumero1
li $a1 51
syscall

print_string(salto)
print_string(segundonumero)
li $v0 8
la $a0 espacionumero2
li $a1 51
syscall
print_string(salto)
convertir_numero(espacionumero1)
convertir_numero(espacionumero2)

li boleano 0
li indice 49
li indice3 50

beq opcion 1 sumar
beq opcion 2 restar
beq opcion 3 multiplicar

sumar:
	
	blt indice 0 fin_sumar
	lb digito1 espacionumero1(indice)
	lb digito23 espacionumero2(indice)
	
	sub digito1 digito1 $s0
	sub digito23 digito23 $s0
	
	add digito23 digito23 digito1
	beqz boleano continue
	li boleano 0
	addi digito23 digito23 1
	continue:
	blt digito23 10 continue2
	
	li boleano 1
	subi digito23 digito23 10
	
	continue2:
	add digito23 digito23 $s0
	sb digito23 espacionumero3(indice3)
	subi indice indice 1
	subi indice3 indice3 1
	b sumar
	
fin_sumar:
beqz boleano no_condicional
li digito23 0x31
sb digito23 espacionumero3($zero)
no_condicional:
print_string(espacionumero1)
print_string(salto)
print_string(espacionumero2)
print_string(salto)
print_string(espacionumero3)
b salir

restar:

multiplicar:

salir:
salir

