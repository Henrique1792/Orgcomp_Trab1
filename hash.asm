.data

#	Tabela Hash
#
# Implementação: Lista Duplamente encadeada
#	Nós: 
#			Endereço anterior
#			Conteúdo
#			Próximo endereço (NULL se fim da pilha)
#
#	Função Hash: Resto da divisão do número a ser inserido (chave)
#
# Funcionalidades:
#		1 - Inserção
#		2 - Remoção
#		3 - Busca
#		4 - Visualização Completa (c/ colisões)
#		
#		-1 - Fim da execução
#
# Loop de impressão do header, caso precise de debugging
#	la $s0, hash_table
#	li $v0, 1
#	li $t1, 0
#	
#	Loop:
#		lw $a0, 0($s0)
#		syscall
#		addi $s0, $s0, 4
#		addi $t1, $t1, 1
#		
#		bne $t1, 16, Loop

.align 0
#Menu Strings
Welcome_str:	.asciiz	"Welcome to Asm Hash Table!"
Select_str:	.asciiz "\n\nPlease, choose an option"
insert_str:	.asciiz "\n1 - Insercao"
remove_str:	.asciiz "\n2 - Remocao"
search_str:	.asciiz "\n3 - Buscar Elemento"
viewAll_str:	.asciiz "\n4 - Visualizar Tudo"
exit_str:	.asciiz "\n-1 - Finalizar a execucao.\n"
invalidOp_str: 	.asciiz "\nCodigo Invalido!! \n\n\n"

#Insert Strings
insert_home: .asciiz "\nForneca uma chave (-1 para retornar ao menu)"

#Remove Strings
remove_home: .asciiz "\nForneca um valor a ser removido (-1 para retornar ao menu)"

#Search Strings

#viewAll Strings


.align 2
hash_size:	.word	16 # sizeof hash table.
hash_table: .space 64 # hash table size set up.

.text
.globl main

main:
	
	HashMenu:
		li $v0, 4 		# Print_str
		la $a0, Welcome_str 	# $a0 = &Welcome_str
		syscall
		
		la $a0, Select_str 	# $a0 = &Select_str
		syscall
		
		la $a0, insert_str 	# $a0 = &insert_str
		syscall
		
		la $a0, remove_str 	# $a0 = &remove_str
		syscall
		
		la $a0, search_str 	# $a0 = &search_str
		syscall
		
		la $a0, viewAll_str 	# $a0 = &viewAll_str
		syscall

		la $a0, exit_str 	# $a0 = &Exit_str
		syscall
		
		
		li $v0, 5 		# read_int
		syscall
		
		
		beq $v0, -1,Exit
		beq $v0, 1, InsertLoop
		beq $v0, 2, RemoveLoop
		#beq $v0, 3, SearchLoop
		#beq $v0, 4, ViewAllLoop
		
		
		li $v0, 4 		# Print_str
		la $a0, invalidOp_str 	# $a0 = &invalidOp_str
		syscall
		
		j HashMenu
	
	
	InsertLoop:


#####Leitura######

		li $v0, 4 #Print_str
		la $a0, insert_home #a0=insert_home
		syscall
		
		li $v0, 5 #Read_int
		syscall		
		beq $v0, -1, HashMenu #v0==-1 ? HashMenu : Insert

#####Leitura#####

####Ajuste do valor Hash#####
		move $t0,$v0 #t0=v0
		div $v0, $v0, 16 #t0=v0/16
		
		mul $t1, $v0, 16  #t1=v0*16
		sub $v0, $t0, $t1 #v0=t0-t1
		move $t1, $v0     #t1=v0

		la $t2, hash_table #t2=&hash_table
		mul $t1, $t1, 4    #ajuste multiplicando por 4 no endereço
		add $t2, $t2, $t1	 #&hash_table[t2+=t1]
		lw $t3, 0($t2)     #t3=hash_table[t2]
####Ajuste do valor Hash####


		bnez $t3, MiddleAlloc # t2!=0 ? MiddleAlloc : FirstAlloc
		
		#FirstAlloc	
			
			div $t1, $t1, 4			#recover hash value
			sw $t0, 0($t2)		  #hash_table[t2]=t0
			
			
		j InsertLoop
		
		MiddleAlloc:
		
		j InsertLoop
	
	
	
	
	RemoveLoop:
	
#####Leitura######

		li $v0, 4 #Print_str
		la $a0, remove_home #a0=insert_home
		syscall
		
		li $v0, 5 #Read_int
		syscall		
		beq $v0, -1, HashMenu #v0==-1 ? HashMenu : Remove

#####Leitura#####
#####Check if 'value' is at header
	la $s0, hash_table
	li $t1, 0
	
	Loop:
		lw $a0, 0($s0)
		addi $s0, $s0, 4
		addi $t1, $t1, 1 
		beq $a0, $v0, Header_Remove #a0==v0? Header_remove : continue
		bne $t1, 16, Loop
#		j Memory_Remove
	Header_Remove:
		sw $zero, 0($s0)
	
	

