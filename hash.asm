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

.align 2
hash_size:	.word	16 # sizeof hash table.

.align 0
Welcome_str:	.asciiz	"Welcome to Asm Hash Table!"
.align 0
Select_str:	.asciiz "\n\nPlease, choose an option"
.align 0
insert_str:	.asciiz "\n1 - Inserção"
.align 0
remove_str:	.asciiz "\n2 - Remoção"
.align 0
search_str:	.asciiz "\n3 - Buscar Elemento"
.align 0
viewAll_str:	.asciiz "\n4 - Visualizar Tudo"
.align 0
exit_str:	.asciiz "\n-1 - Finalizar a execução.\n"
.align 0
invalidOp_str: 	.asciiz "\nCódigo Inválido\!\! \n\n\n"

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
		#beq $v0, 1, SelectLoop
		#beq $v0, 2, RemoveLoop
		#beq $v0, 3, SearchLoop
		#beq $v0, 4, ViewAllLoop
		
		
		li $v0, 4 		# Print_str
		la $a0, exit_str 	# $a0 = &invalidOp_str
		syscall
		
		j HashMenu
	
	Exit:
		li $v0, 10 		# exit
		syscall
