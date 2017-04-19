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


.align 0
#Menu Strings
Welcome_str:	.asciiz	"Welcome to Asm Hash Table!"
Select_str:	.asciiz "\n\nPlease, choose an option"
insert_str:	.asciiz "\n1 - Insercao"
remove_str:	.asciiz "\n2 - Remocao"
search_str:	.asciiz "\n3 - Buscar Elemento"
viewAll_str:	.asciiz "\n4 - Visualizar Tudo"
exit_str:	.asciiz "\n-1 - Finalizar a execucao.\n"
invalidOp_str: 	.asciiz "\nCodigo Invalido\!\! \n\n\n"

#Insert Strings
insert_home: .asciiz "\nForneca uma chave (-1 para retornar ao menu)"




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
		#beq $v0, 2, RemoveLoop
		#beq $v0, 3, SearchLoop
		#beq $v0, 4, ViewAllLoop
		
		
		li $v0, 4 		# Print_str
		la $a0, exit_str 	# $a0 = &invalidOp_str
		syscall
		
		j HashMenu
	
	
	InsertLoop:

		li $v0, 4 #Print_str
		la $a0, insert_str
		syscall
		
		li $v0, 5 #Read_int
		syscall
		
		move $t0,$v0 #t0=v0
		div $v0, $v0, 16 #t0=v0/16
		mflo $t1	#Segundo o greensheet da arquitetura MIPS, o registrador LO
							#armazena o resto de uma operação de divisão. 
		
		la $t2, hash_table # t2=&hash_table
		mul $t1, $t1, 4
		add $t2, $t2, $t1 #&hash_table[t2+=t1]
		
		
	Exit:
		li $v0, 10 		# exit
		syscall
