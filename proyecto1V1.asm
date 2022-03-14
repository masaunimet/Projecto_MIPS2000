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
li indice 0
loop_llenar:
	bgt indice 49 fin_loop_llenar
	sb $s0 %cadena(indice)
	
	addi indice indice 1
	b loop_llenar
	
fin_loop_llenar:
addi indice indice 1
sb $zero %cadena(indice)
.end_macro

.macro llenar_ceros2(%cadena)
li indice 0
loop_llenar:
	bgt indice 100 fin_loop_llenar2
	sb $s0 %cadena(indice)
	
	addi indice indice 1
	b loop_llenar
	
fin_loop_llenar2:
addi indice indice 1
sb $zero %cadena(indice)
.end_macro

.macro convertir_numero(%cadena)
li indice 0
li indice2 0
li tamano2 0
loop:
	
	lb digito1 %cadena(indice)
	
	beqz digito1 fin_loop
	beq digito1 0x0A llenar_ceros
	
	bgt indice 50 inicio
	blt digito1 0x30 inicio
	bgt digito1 0x39 inicio
 
	addi indice2 indice2 1
	addi indice indice 1
	addi tamano2 tamano2 1
	
	b loop
	
	llenar_ceros: 
		 
		 beq indice 50 llenar_ceros_part2
		 li digito1 0x30 
		 sb digito1 %cadena(indice)
		  
		 addi indice indice 1 
		 b llenar_ceros
		 
	llenar_ceros_part2:
	
	li indice 49
	subi indice2 indice2 1
		
	loop_ceros:
		
		bltz indice2 fin_loop
		
		lb digito1 %cadena(indice2)
		sb $s0 %cadena(indice2)
		sb digito1 %cadena(indice)
			
		subi indice indice 1
		subi indice2 indice2 1
		
		b loop_ceros
		
fin_loop:
.end_macro

.macro comparar_tamanos #compara si el primero es el mas grande o no
bgt tamano1 tamano2 mas_grande
blt tamano1 tamano2 mas_peque

iguales:
subi tamano1 tamano1 50
subi tamano2 tamano2 50
mul tamano1 tamano1 -1
mul tamano2 tamano2 -1

loop_comparativo:
	
	bgt tamano1 49 mas_peque
	
	lb digito1 espacionumero1(tamano1)
	lb digito23 espacionumero2(tamano2)
	
	bgt digito1 digito23 mas_grande
	blt digito1 digito23 mas_peque
	
	addi tamano1 tamano1 1
	addi tamano2 tamano2 1
	
	b loop_comparativo

mas_grande:
li boleano 1
b fin_comparar_tamanos
	
mas_peque:
li boleano 0

fin_comparar_tamanos:
.end_macro

.data
mensaje: .asciiz "Ingrese operacion a realizar \n1. Sumar\n2. Restar\n3. Multiplicar\n4. Salir\n"
salto: .asciiz "\n"
mensajeerror : .asciiz "ingrese una opcion del 1 al 4"
primernumero: .asciiz "Ingrese el primer numero: "
segundonumero: .asciiz "Ingrese el segundo numero:"
resultado: .asciiz "El resultado es:\n"
espacionumero1: .space 51
espacionumero2: .space 51
espacionumero3: .space 101

.text

.eqv opcion $t0
.eqv digito1 $t1
.eqv digito23 $t2
.eqv boleano $t3 
.eqv indice $t4 
.eqv indice2 $t5
.eqv indice3 $t6
.eqv tamano1 $t7
.eqv tamano2 $t8

li $s0 0x30
li $s1 10

inicio:
llenar_ceros(espacionumero1)
llenar_ceros(espacionumero2)
llenar_ceros2(espacionumero3)
print_string(mensajeerror)
print_string(salto)
print_string(mensaje)

li $v0 5
syscall
move opcion $v0

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
convertir_numero(espacionumero1)
move tamano1 tamano2
convertir_numero(espacionumero2)

li boleano 0
li indice 49
li indice2 100
li indice3 -1

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
	blt digito23 $s1 continue2
	
	li boleano 1
	sub digito23 digito23 $s1
	
	continue2:
	add digito23 digito23 $s0
	sb digito23 espacionumero3(indice2)
	subi indice indice 1
	subi indice2 indice2 1
	b sumar
	
fin_sumar:
beqz boleano no_condicional
li digito23 0x31
sb digito23 espacionumero3(indice2)
no_condicional:
print_string(salto)
print_string(resultado)
print_string(espacionumero3)
print_string(salto)
print_string(salto)
b inicio

restar:
comparar_tamanos
beqz boleano segundo_mayor
li indice 49
li indice2 100

	primer_mayor:
	li boleano 0
	
	loop_resta:
		
		blt indice 0 fin_resta
		lb digito1 espacionumero1(indice)
		lb digito23 espacionumero2(indice)
		
		beqz boleano no_condicional_resta1
		li boleano 0
		subi digito1 digito1 1
		
		no_condicional_resta1:
		sub digito1 digito1 $s0
		sub digito23 digito23 $s0
		
		sub digito23 digito1 digito23
		
		bgez digito23 normal1
		li boleano 1 
		add digito23 digito23 $s1
		
		normal1:
		add digito23 digito23 $s0
		sb digito23 espacionumero3(indice2)
		
		subi indice indice 1
		subi indice2 indice2 1
		
		b loop_resta

	segundo_mayor:
		
		blt indice 0 fin_resta_especial
		lb digito1 espacionumero1(indice)
		lb digito23 espacionumero2(indice)
		
		beqz boleano no_condicional_resta2
		li boleano 0
		subi digito23 digito23 1
		
		no_condicional_resta2:
		sub digito1 digito1 $s0
		sub digito23 digito23 $s0
		
		sub digito23 digito23 digito1
		
		bgt digito23 -1 normal2
		li boleano 1 
		add digito23 digito23 $s1
		
		normal2:
		add digito23 digito23 $s0
		sb digito23 espacionumero3(indice2)
		
		subi indice indice 1
		subi indice2 indice2 1
		
		b segundo_mayor

fin_resta_especial:
li digito23 0x2D
sb digito23 espacionumero3($zero)

fin_resta:
print_string(salto)
print_string(resultado)
print_string(espacionumero3)
print_string(salto)
print_string(salto)
b inicio

multiplicar:
li indice2 49
bltz indice fin_mul
lb digito1 espacionumero1(indice)
sub digito1 digito1 $s0
subi indice indice 1
addi indice3 indice3 1

loop_mul:
	
	bltz indice2 multiplicar
	
	lb digito23 espacionumero2(indice2)
	sub digito23 digito23 $s0
	
	mul digito23 digito23 digito1
	beqz boleano no_condicional_mul
	add digito23 digito23 boleano
	li boleano 0
	
	no_condicional_mul:
	blt digito23 $s1 normal_mul
	div digito23 $s1
	mfhi digito23
	mflo boleano
	
	normal_mul:
	addi indice2 indice2 51
	sub indice2 indice2 indice3
	lb opcion espacionumero3(indice2)
	sub opcion opcion $s0
	add digito23 digito23 opcion
	blt digito23 $s1 continue_mul
	sub digito23 digito23 $s1
	subi indice2 indice2 1
	lb opcion espacionumero3(indice2)
	addi opcion opcion 1
	sb opcion espacionumero3(indice2)
	addi indice2 indice2 1
	
	continue_mul:
	add digito23 digito23 $s0
	sb digito23 espacionumero3(indice2)
	subi indice2 indice2 52
	b loop_mul
	
fin_mul:
print_string(salto)
print_string(resultado)
print_string(espacionumero3)
print_string(salto)
print_string(salto)
b inicio

salir:
salir

