# -------------------------------------------------- #
# SSC0112 - Organiza��o de Computadores Digitais - 1 #
# ------------ Trabalho #1 - Tabela Hash ----------- #
# Gustavo Santiago			     8937416 #
# Henrique Freitas			     8937225 #
# Henrique Loschiavo			     8936972 #
# Luiz Dorici				     4165850 #
# -------------------------------------------------- #
# Implementacao: Lista duplamente encadeada
#	Nodes: 
#		Conteudo (key)
#		Endereco anterior (NULL se cabeca) (prev)
#		Proximo endereco (NULL se fim da pilha) (next)
#
#	Funcao Hash: Resto da divisao do numero a ser inserido (key) por 16
#
# Funcionalidades:
#		1 - Insercao
#		2 - Remocao
#		3 - Busca
#		4 - Visualizacao Completa
#		
#		-1 - Fim da execucao
# ---------------------------------------------- #

.data

.align 0
# Menu Strings
welcome_str:	.asciiz	"\n\nWelcome to Asm Hash Table!"
select_str:	.asciiz "\nPlease, choose an option: "
insert_str:	.asciiz "\n1 - Insert"
remove_str:	.asciiz "\n2 - Remove"
search_str:	.asciiz "\n3 - Search"
viewAll_str:	.asciiz "\n4 - View All"
exit_str:	.asciiz "\n-1 - Quit\n"
invalidOp_str: 	.asciiz "\nInvalid Code!! \n\n\n"

# Separators
comma_sep: .asciiz ", "
node_sep: .asciiz "\n-----------------------"

# Insert Strings
insert_home: .asciiz "\n\n>Type a key to be inserted (-1 returns to menu): "
insert_success: .asciiz ">Key successfully inserted: "
insert_dup: .asciiz ">Key already exists: "

# Remove Strings
remove_home: .asciiz "\n\n>Type a key to be removed (-1 returns to menu): "
remove_success: .asciiz ">Key successfully removed: "
remove_notfound: .asciiz ">Key not found, no nodes removed"

# Search Strings
search_home: .asciiz "\n\n>Type a key to be recovered (-1 returns to menu): "
search_success: .asciiz ">Key successfully recovered: "
search_notfound: .asciiz ">Key not found, no nodes recovered"

# ViewAll Strings
viewAll_index: .asciiz "\n\nTable index: "
viewAll_clear: .asciiz "\n\tClear index, nothing to show"
viewAll_key: .asciiz "\n\tKey: "
viewAll_prev: .asciiz "\n\tPrev: "
viewAll_next: .asciiz "\n\tNext: "

.align 2
comma: .word ','

.align 2
hash_size: .word 16 		# Sizeof hash table
hash_table: .space 64		# Hash table (16 words * 4 bytes)

.text
.globl main

# MAIN MENU #
# ------------------------------------------------------------------------#

main:

hashMenu:
	li $v0, 4		# Print str
	la $a0, welcome_str	# $a0 = &Welcome_str
	syscall
		
	la $a0, select_str	# $a0 = &select_str
	syscall
		
	la $a0, insert_str	# $a0 = &insert_str
	syscall
		
	la $a0, remove_str	# $a0 = &remove_str
	syscall
		
	la $a0, search_str	# $a0 = &search_str
	syscall
		
	la $a0, viewAll_str	# $a0 = &viewAll_str
	syscall

	la $a0, exit_str	# $a0 = &Exit_str
	syscall
		
	li $v0, 5		# Read int
	syscall
		
	beq $v0, -1, Exit
	beq $v0, 1, insertLoop
	beq $v0, 2, removeLoop
	beq $v0, 3, searchLoop
	beq $v0, 4, viewAllLoop
		
		
	li $v0, 4		# Print str
	la $a0, invalidOp_str	# $a0 = &invalidOp_str
	syscall	
j hashMenu
# ------------------------------------------------------------------------#

# NODE ALLOCATION #
# ------------------------------------------------------------------------#
allocNode:			# AllocNode: receives $a0 = key, $a1 = prev, $a2 = next, returns node at $v0
	sw $a0, 4($sp)		# Saves $a0 in stack
	li $a0, 12		# Node size = 12 bytes (3 words * 4 bytes)
	li $v0, 9		# SBRK code
	syscall			# SBRK call
	
	lw $a0, 4($sp)		# Recovers $a0 from stack
	
	sw $a0, 0($v0)		# Stores "key" in node
	sw $a1, 4($v0)		# Stores "prev" in node
	sw $a2, 8($v0)		# Stores "next" in node
	
	jr $ra			# Returns execution to original flow
# ------------------------------------------------------------------------#
	
# INSERT FUNCTIONS #
# ------------------------------------------------------------------------#
insertLoop:
	#####Leitura######
	li $v0, 4 		# Print_str
	la $a0, insert_home	# $a0 = insert_home
	syscall
		
	li $v0, 5 		# Read_int
	syscall
	
	beq $v0, -1, hashMenu	# $v0 == -1 ? HashMenu : Insert
	#####Leitura#####

	####Ajuste do valor Hash#####
	move $s0, $v0		# $s0 = $v0 (valor lido salvo)
	div $v0, $v0, 16 	# $v0 = $v0 / 16
		
	mul $t0, $v0, 16	# $t0 = $v0 * 16
	sub $v0, $s0, $t0	# $v0 = $s0 - $t0 (resto da divisão)
	move $s1, $v0		# $s1 = $v0 (posição hash salva)

	la $t0, hash_table	# $t0 = &hash_table
	mul $t1, $s1, 4		# ajuste multiplicando posição por 4 no endereço
	add $t0, $t0, $t1	#&hash_table[$t0 += $t1]
	lw $t1, 0($t0)		# $t1 = hash_table[$t0]
	####Ajuste do valor Hash####

	bnez $t1, middleAlloc	# $t1 != 0 ? MiddleAlloc : FirstAlloc
	
	j firstAlloc
j insertLoop

firstAlloc:			# HEAD insertion in table
	move $a0, $s0		# "key" argument
	li $a1, 0		# "prev" argument
	li $a2,	0		# "next" argument
	jal allocNode		# Allocates node into $v0
	
	la $t1, 0($v0)		# Loads node address into $t1
	sw $t1, 0($t0)		# Stores node address into table
	
	lw $t1, 0($t0)		# Load address from table
	
insertSuccess:
	li $v0, 4		# Print str
	la $a0, insert_success	# Insert success message
	syscall			# Print str
	j insertPrint
	
insertDup:
	li $v0, 4		# Print str
	la $a0, insert_dup	# Insert success message
	syscall			# Print str

insertPrint:
	li $v0, 1		# Print int
	lw $a0, 0($t1)		# Key inserted
	syscall			# Print int
	
	li $v0, 4		# Print str
	la $a0, comma_sep	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print int
	lw $a0, 4($t1)		# Prev inserted
	syscall			# Print int
	
	li $v0, 4		# Print str
	la $a0, comma_sep	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print int
	lw $a0, 8($t1)		# Next inserted
	syscall			# Print int
	
j insertLoop
		
middleAlloc:
	move $a0, $s0		# "key" argument
	li $a2,	0		# "next" argument
	
middleNode:
	lw $t2, 0($t1)		# $t2 = "key"
	
	beq $t2, $s0, insertDup # If $t2 = $s0, "key" already exists
	
	lw $t2, 8($t1)		# $t2 = "next"

	beqz $t2, middleNodeInsert # If $t2 = 0, insert at end
	
	move $t1, $t2		# $t1 = $t2
j middleNode
	
middleNodeInsert:
	la $a1, ($t1)		# $a1 = $t1 = "prev" argument
	jal allocNode		# Allocates node into $v0
	
	la $t2, 0($v0)		# Loads node address into $t2
	sw $t2, 8($t1)		# Stores node address as current node's "next"
	
	lw $t2, 8($t1)		# Loads inserted node in $t2
	move $t1, $t2		# Moves to inserted node for success print
j insertSuccess
# ------------------------------------------------------------------------#

# REMOVE FUNCTIONS #
# ------------------------------------------------------------------------#
removeLoop:
	#####Leitura######
	li $v0, 4 		# Print_str
	la $a0, remove_home	# $a0 = remove_home
	syscall
		
	li $v0, 5		# Read_int
	syscall
	
	beq $v0, -1, hashMenu	# $v0 == -1 ? HashMenu : Insert
	#####Leitura#####
	
	####Ajuste do valor Hash#####
	move $s0, $v0		# $s0 = $v0 (valor lido salvo)
	div $v0, $v0, 16	# $v0 = $v0 / 16
		
	mul $t0, $v0, 16	# $t0 = $v0 * 16
	sub $v0, $s0, $t0	# $v0 = $s0 - $t0 (resto da divisão)
	move $s1, $v0		# $s1 = $v0 (posição hash salva)

	la $t0, hash_table	# $t0 = &hash_table
	mul $t1, $s1, 4		# ajuste multiplicando posição por 4 no endereço
	add $t0, $t0, $t1	# &hash_table[$t0 += $t1]
	lw $t1, 0($t0)		# $t1 = hash_table[$t0]
	####Ajuste do valor Hash####
	
	bnez $t1, removeNode	# $t1 != 0 ? removeNode : removeNotFound

removeNotFound:
	la $a0, remove_notfound	# Node not found
	li $v0, 4		# Print str
	syscall
j removeLoop

removeNode:			# Runs through each node of a index for remotion, starting from head
	lw $t2, 0($t1)		# Loads "key" into $t2
	
	bne $t2, $s0, removeNodeLoop # If $t2 != $s0, value is not on head
	
	lw $t2, 8($t1)		# Else, load "next" into $t2
	sw $t2, 0($t0)		# And store it as the head value for the index
	
	beqz $t2, removeSuccess	# If $t2 is NULL, removing is complete
	
	sw $zero, 4($t2)	# Else, set "prev" as NULL
	
removeSuccess:
	li $v0, 4		# Print str
	la $a0, remove_success	# Remove success message
	syscall			# Print str
	
	li $v0, 1		# Print str
	lw $a0, 0($t1)		# Key removed
	syscall			# Print str
	sw $zero, 0($t1)	# Set Key as NULL
	
	li $v0, 4		# Print str
	la $a0, comma_sep	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print str
	lw $a0, 4($t1)		# Prev removed
	syscall			# Print str
	sw $zero, 4($t1)	# Set Prev as NULL
	
	li $v0, 4		# Print str
	la $a0, comma_sep	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print str
	lw $a0, 8($t1)		# Next removed
	syscall			# Print str
	sw $zero, 8($t1)	# Set Next as NULL
j removeLoop
	
removeNodeLoop:
	beqz $t1, removeNotFound # If $t1 = 0, node not found (end of nodes)
	
	lw $t2, 0($t1)		# Loads "key" into $t2
	beq $t2, $s0, removeNodeLink # If $t2 = $s0, set linking and remove node
	
	lw $t2, 8($t1)		# Loads "key" into $t2
	move $t1, $t2		# $t1 = $t2
j removeNodeLoop

removeNodeLink:
	lw $t3, 8($t1)		# $t3 = $t1 "next"
	
	lw $t2, 4($t1)		# $t2 = $t1 "prev"
	sw $t3, 8($t2)		# $t2 "next" = $t1 "next"
	
	beqz $t3, removeSuccess	# If $t1 "next" = 0, removing is complete
	
	lw $t3, 4($t1)		# Else, $t3 = $t1 "prev"
	
	lw $t2, 8($t1)		# $t2 = $t1 "next"
	sw $t3, 4($t2)		# $t2 "prev" = $t1 "prev"
j removeSuccess
# ------------------------------------------------------------------------#

# SEARCH FUNCTIONS
# ------------------------------------------------------------------------#
searchLoop:			# Seeks the desired key value in the hash table
	#####Leitura######
	li $v0, 4		# Print_str
	la $a0, search_home	# $a0 = insert_home
	syscall
		
	li $v0, 5		# Read_int
	syscall
	
	beq $v0, -1, hashMenu	# $v0 == -1 ? HashMenu : Insert
	#####Leitura#####
	
	####Ajuste do valor Hash#####
	move $s0, $v0		# $s0 = $v0 (valor lido salvo)
	div $v0, $v0, 16	# $v0 = $v0 / 16
		
	mul $t0, $v0, 16	# $t0 = $v0 * 16
	sub $v0, $s0, $t0	# $v0 = $s0 - $t0 (resto da divisão)
	move $s1, $v0		# $s1 = $v0 (posição hash salva)

	la $t0, hash_table	# $t0 = &hash_table
	mul $t1, $s1, 4		# ajuste multiplicando posição por 4 no endereço
	add $t0, $t0, $t1	# &hash_table[$t0 += $t1]
	lw $t1, 0($t0)		# $t1 = hash_table[$t0]
	####Ajuste do valor Hash####
	
	bnez $t1, searchNode	# $t1 != 0 ? searchNode : searchNotFound
	
searchNotFound:
	la $a0, search_notfound # Node not found
	li $v0, 4		# Print str
	syscall
j searchLoop

searchFound:
	li $v0, 4		# Print str
	la $a0, search_success	# Node found
	syscall			# Print str
	
	li $v0, 1		# Print int
	lw $a0, 0($t1)		# Key
	syscall			# Print str
j searchLoop

searchNode:
	lw $t2, 0($t1)		# $t2 = current key
	
	beq $t2, $s0, searchFound # If $t2 = $s0, key was found
	
	lw $t2, 8($t1)		# $t2 = next
	beqz $t2, searchNotFound # If $t2 = 0, key was not found (end of nodes)
	
	move $t1, $t2		# $t1 = $t2 (go to the next node)
j searchNode
# ------------------------------------------------------------------------#

# VIEW ALL FUNCTIONS #
# ------------------------------------------------------------------------#		
viewAllLoop:			# Show every node for each index in the hash table
	la $t0, hash_table	# $t0 = &hash_table
	li $t1, 0		# $t1 = i = 0
	lw $t2, hash_size	# $t2 = hash_size
viewAllLoopAux:
	beq $t1, $t2, hashMenu	# if i = hash_size, return to menu
	
	li $v0, 4		# Print str
	la $a0, viewAll_index	# Current index
	syscall			# Print str
	
	li $v0, 1		# Print int
	move $a0, $t1		# i
	syscall			# Print int
	
	lw $t3, 0($t0)		# $t3 = &hash_table[i]
	bnez $t3, viewAllNode	# If $t3 != 0, there is a node
	
	li $v0, 4		# Print str
	la $a0, viewAll_clear	# Clear index
	syscall			# Print str
	
viewAllNextIndex:
	addi $t0, $t0, 4	# hash_table[i++]
	addi $t1, $t1, 1	# i++
j viewAllLoopAux

viewAllNode:			# Prints current node
	li $v0, 4		# Print str
	la $a0, viewAll_key	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print int
	lw $a0, 0($t3)		# "key"
	syscall			# Print int
	
	li $v0, 4		# Print str
	la $a0, viewAll_prev	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print int
	lw $a0, 4($t3)		# "prev"
	syscall			# Print int
	
	li $v0, 4		# Print str
	la $a0, viewAll_next	# Separator
	syscall			# Print str
	
	li $v0, 1		# Print int
	lw $a0, 8($t3)		# "next"
	syscall			# Print int
	
	beqz $a0, viewAllNextIndex # If "next" = 0, go to the next index
	
	move $t3, $a0		# Else, move to the "next" node
	
	li $v0, 4		# Print str
	la $a0, node_sep	# Separator
	syscall			# Print str
j viewAllNode
# ------------------------------------------------------------------------#

# EXIT ROUTINE #
# ------------------------------------------------------------------------#
Exit:
	li $v0, 10		# Quit code
	syscall			# Quit execution
# ------------------------------------------------------------------------#
