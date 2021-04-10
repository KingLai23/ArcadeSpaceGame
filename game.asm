#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: King Lai, 1006030723, laiking2
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 4
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
#     1. Scoring System -> you gain points by staying alive (9 points per game loop)
#     2. Automatic Difficulty Increase
#            o Level 0: 1 asteroid, 40ms refresh rate
#            o Level 1: 2 asteroids, 36ms refresh rate
#            o Level 2: 3 asteroids, 32ms refresh rate
#            o Level 3: 3 asteroids, 24m refresh rate (pretty much impossible to survive)
#     3. Pick-up Items
#            o Red Heart: +12 health
#            o Yellow Pellet: +4 Health 
#            o Blue Pellet: +150 to +400 points
#     4. Smooth Graphics -> only the exact pixels that need to be editted are redrawn
#
# *** The following features aren't approved but I added them for fun
#         1. Highscore Tracking (even after you close the game and re-open)
#                o Tracks the top 3 highscores of all-time
#                o Clear UI to indicate new highscores and display highscores after each game
#                o You can skip viewing the highscore info. screens by pressing 'a'
#	  2. Special Feature | Konami Cheat Code (kinda)
#	         o Pressing the following sequence: W -> S -> A -> D -> B, changes your spaceship color
#
# Link to video demonstration for final submission:
# - YouTube: https://youtu.be/1GL9gkl_LaY
#
# Are you OK with us sharing the video with people outside course staff?
# - YES, and please share this project github link as well!
# - https://github.com/KingLai23/ArcadeSpaceGame 
#
# Any additional information that the TA needs to know:
# - IMPORTANT
#   Before you run my game, you need to set-up the highscore textfile:
#      1. Create a textfile called "highscores.txt", and fill the first row with 12 zeros -> 000000000000
#      2. In the .data section, put the full path name of highscores.txt in hs_filename
#   On line 137, there is a constant called ENABLE_COLLISIONS
#        o Set to non-zero number to enable collision detection.
#        o Set to zero to disable collision detection (PS: the game will run forever, so press 'e' to exit if you're in-game).
#   On line 138, there is a constant called CLEAR_HIGHSCORES
#        o Set to non-zero number to clear highscores.
#          (PS: don't forget to set it back to zero, or else the game will clear all highscores everytime you run it)
#        o Set to zero to retain highscores.
#
# - The following are just info. about the UI
#      o The start screen indefinitely prompts the user to start by pressing a, 
#        or you can exit by pressing e.
#      o The gameplay has 3 HUD sections:
#            1. The green bar is your health bar.
#            2. The The blue dashes on the bottom left corner is your current level.
#            3. The bottom right number is your score.
#      o Yellow flying items give you +4 health.
#      o Red flying items give you +12 health.
#      o Blue flying items give you additional points, ranging from 150 to 400.
#      o At anytime during the gameplay you can press 'p' to restart, or 'e' to exit.
#      o The gameover screen lasts 4 seconds.
#      o The new highscore screen lasts about 6 seconds, or you could skip by pressing 'a'.
#      o The highscore list screen lasts about 9 seconds or you could skip by pressing 'a'.
#      o You cannot restart or exit the game while in the gameover and highscore screens.
#      o Once the highscore list screen is finished displaying, it will
#        bring you back to the start screen.	
#
#####################################################################

.eqv	BASE_ADDRESS	0x10008000
.eqv	MMIO_ADDRESS	0xffff0000
.eqv	WIDTH	32
.eqv	BYTE	4

.eqv	HEALTH_BAR_START	144
.eqv	HEALTH_BAR	236

.eqv	START_HEALTH	24

.eqv	HEALTH_GEN_RATE	66 # 1.5% chance of spawning health regen 
.eqv	POINT_GEN_RATE	50 # 2.00% chance of spawning bonus point item

# Score Related
.eqv	SCORE_INCREASE	3
.eqv	SCORE_DECREASE	29
.eqv	POINT_GAIN_BASE	150
.eqv	POINT_GAIN_ADDITIONAL	251

# Spaceship Starting Position
.eqv	SS_START_X 	6
.eqv	SS_START_Y	15

# Delays
.eqv	DEATH_DELAY	800
.eqv	GAMEOVER_DELAY	4000
.eqv	SHOW_HS_DELAY	8000
.eqv	WRITING_DELAY	125
.eqv	ITEM_PICKUP_DELAY	70

# Level-up Requirements
.eqv	LEVEL1	950
.eqv	LEVEL2	2650
.eqv	LEVEL3	5000

# Asteroid Speeds
.eqv	SPEED0	40
.eqv	SPEED1	36
.eqv	SPEED2	32
.eqv	SPEED3	16

# Health Item Colors
.eqv	HEALTH_ITEM1_COLOR1	0x00a87932
.eqv	HEALTH_ITEM1_COLOR2	0x00d1a336
.eqv	HEALTH_ITEM2_COLOR1	0x00802e22
.eqv	HEALTH_ITEM2_COLOR2	0x00c25236

# Health Bar Colors
.eqv	HEALTH_BAR_COLOR1	0x00256337 # DARKER
.eqv	HEALTH_BAR_COLOR2	0x00449c5e # LIGHTER
.eqv	HEALTH_BAR_COLOR3	0x00a87932
.eqv	HEALTH_BAR_COLOR4	0x00d1a336
.eqv	HEALTH_BAR_COLOR5	0x00802e22
.eqv	HEALTH_BAR_COLOR6	0x00c25236

# Spaceship Colors
.eqv	SS_COLOR1	0x00d0def5
.eqv	SS_COLOR2	0x00456487
.eqv	SS_COLOR3	0x00d6503e
.eqv	SS_KONAMI	0x004794b5

# Asteroid Colors
.eqv	ASTEROID_COLOR2	0x007c818a
.eqv	ASTEROID_COLOR1 0x0050555e

# Generic Colors
.eqv	BLACK		0x00000000
.eqv	WHITE		0x00ffffff
.eqv	DARK_GREY	0x00323232
.eqv	LIGHT_GREY	0x00525252
.eqv	RED	0x00d6503e
.eqv	YELLOW	0x00d6b333
.eqv	BLUE	0x006987b8
.eqv	LIGHT_BLUE	0x0099d9ea
.eqv	DARK_BLUE	0x003e5982
.eqv	GREEN	0x00449c5e

# Debug Configurations
.eqv	ENABLE_COLLISIONS	1 # disable (0) and enable (1) collisions -> mainly for debugging
.eqv	CLEAR_HIGHSCORES	0 # clear highscores file -> set to non-zero number to clear

.data
game_info:	.word	0:4 # game information: delay, health, end of health bar, points
ss_pixel: .word	0:2 # spaceship most significant coordinates: x, y
ss_shift: .word	0:3 # spaceship movement: left/right, up/down, indicator
asteroids:	.word	0, 32, 0, 0, 34, 0, 0, 33, 0 # asteroid info: (read in groups of 3): type, x pos., y pos.
health_item1:	.word	0:3
health_item2:	.word	0:3
point_item:	.word	0:3
ss_color:	.word	0:2

hs_filename:	.asciiz	"C:/Users/KiNg/Desktop/B58/Final Project/highscores.txt"
hs_content:	.byte	48:12 # initialize hs array with all 0s (ASCII 48 <-> '0')
temp:	.word	0

konami_cc:	.word	0:5 # the 5 most recent key presses are stored here to check for the cheat code

start_time:	.word	0

# BELOW ARE PRINT STATEMENTS FOR DEBUGGING PURPOSES
print_debug:	.asciiz " here\n"
print_collision:	.asciiz "collision\n"
print_line_sep:	.asciiz	"-----------------------------\n"
print_du:	.asciiz "difficulted updated\n"
print_gain4:	.asciiz "generated item: HEALTH GAIN\n"
print_item:	.asciiz "generated item: POINT BONUS\n"
print_finalscore:	.asciiz	"FINAL SCORE: "
print_timeelapsed:	.asciiz	"TIME ELAPSED: "
print_newline:	.asciiz " \n"
print_comma:	.asciiz ", "
print_period:	.asciiz	"."
print_zero:	.asciiz "0"
print_time:	.asciiz	"s\n"
print_konami:	.asciiz	"KONAMI CC SUCCESS\n"

.text
.globl config

# startup configurations go here:
config:
	li $s0, BASE_ADDRESS # base address of the bit map
	li $s1, WIDTH # width of the display
 	li $s2, BYTE # offset per byte

	li $t0, CLEAR_HIGHSCORES
	beqz $t0, start_screen
	jal write_to_hsfile
	j start_screen

# the starting screen
start_screen:
	jal wipe_screen_wrapper # completely clearing the screen
	jal draw_logo # drawing the logo
	
	# the calls below draw the dashes in the logo
	li $a0, 2184
	li $a1, 2224
	jal draw_dash_wrapper
	li $a0, 2240
	li $a1, 2256
	jal draw_dash_wrapper
	li $a0, 2356
	li $a1, 2356
	jal draw_dash_wrapper
	li $a0, 2384
	li $a1, 2424
	jal draw_dash_wrapper
	li $a0, 2472
	li $a1, 2500
	jal draw_dash_wrapper
	
	# jumping to the continuous start prompt
	li $v1, 0
	j start_prompt

# continually prompts the user to start the game
start_prompt:
	jal check_start_key
	beq $v1, 10, game_start
	
	li $a0, WHITE
	jal write_prompt
	
	li $v0, 32
	li $a0, 400
	syscall
	
	li $a0, BLACK
	jal write_prompt
	
	li $v0, 32
	li $a0, 400
	syscall
	
	j start_prompt

# checking if a key was pressed in the starting screen
check_start_key:
	li $t9, MMIO_ADDRESS
	lw $t8, 0($t9)
	beq $t8, 1, check_can_start
	jr $ra
	
# checks if the 'a' key was pressed, indicating the game can start	
check_can_start:
	lw $t2, 4($t9) # storing the key that got pressed
	beq $t2, 0x61, signify_start_game # checking if the key pressed was a
	beq $t2, 0x65, exit # checking if the user closed the game
	jr $ra

# signifies that the game can start
signify_start_game:
	li $v1, 10
	jr $ra
	
# starts the game after the 'a' key is detected
game_start:
	li $a0, RED
	jal write_prompt # writing the prompt in RED to indicate the game will start
	
	li $v0, 32
	li $a0, 1000
	syscall

	j game_init # starting the game

# initializes the game
game_init:
	li $v0, 4
	la $a0, print_line_sep
	syscall
	
	la $t0, start_time
	li $v0, 30
	syscall
	sw $a0, 0($t0) # storing the starting time

	jal wipe_screen_wrapper # completely clearing the screen

	# initializing game information
	la $t0, game_info
	li $t1, SPEED0
	sw $t1, 0($t0)
	li $t1, START_HEALTH
	sw $t1, 4($t0)
	li $t1, HEALTH_BAR
	sw $t1, 8($t0)
	sw $zero, 12($t0)
	
	# initializing items
	li $t1, -1
	la $t0, health_item1
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	la $t0, health_item2
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	la $t0, point_item
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)

	# clearing konami_cc stack
	la $t0, konami_cc
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	sw $zero, 12($t0)
	sw $zero, 16($t0)

	# initializing spaceship colors
	la $t0, ss_color
	li $t1, SS_COLOR1
	sw $t1, 0($t0)
	li $t1, SS_COLOR2
	sw $t1, 4($t0)

	# drawing the health bar
	jal draw_health_bar
	
	# initializing the start position of the spaceship
	la $t0, ss_pixel
	li $t1, SS_START_X
	sw $t1, 0($t0)
	li $t1, SS_START_Y
	sw $t1, 4($t0)
	
	# initializing the shift detector
	la $t0, ss_shift
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	
	# generating asteroids
	la $t0, asteroids
	
	# generating first asteroid
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall
	sw $a0, 0($t0) # setting asteroid type
	li $a0, 33
	sw $a0, 4($t0) # setting starting x position
	li $v0, 42
	li $a0, 0
	li $a1, 6
	syscall
	addi $a0, $a0, 5
	sw $a0, 8($t0) # setting starting y position
	
	# generating second asteroid
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall
	sw $a0, 12($t0) # setting asteroid type
	li $a0, 35
	sw $a0, 16($t0) # setting starting x position
	li $v0, 42
	li $a0, 0
	li $a1, 7
	syscall
	addi $a0, $a0, 13
	sw $a0, 20($t0) # setting starting y position
	
	# generating third asteroid
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall
	sw $a0, 24($t0) # setting asteroid type
	li $a0, 32
	sw $a0, 28($t0) # setting starting x position
	li $v0, 42
	li $a0, 0
	li $a1, 6
	syscall
	addi $a0, $a0, 22
	sw $a0, 32($t0) # setting starting y position
	
	# finished initializing the game, jump to the game loop
	j game_loop

# THE FOLLOWING 2 LABELS CLEAR THE DISPLAY BY FILLING EVERY PIXEL WITH BLACK
wipe_screen_wrapper:
	li $a0, 0
	li $a1, BLACK
	j wipe_screen

# Completely wipes the screen by coloring it black
wipe_screen:
	bgt $a0, 4092, quick_return
	add $t0, $a0, $s0
	sw $a1, 0($t0)
	addi $a0, $a0, 4
	j wipe_screen

#----------------------------------------------------------------#
#                THE MAIN GAME LOOP STARTS HERE                  #
#----------------------------------------------------------------#
#    The order of the game loop is as follows:
#    1. update game difficulty
#    2. sleep program to simulate animation
#    3. write score
#    4. draw asteroids
#    5. draw health items	
#    6. draw bonus point item
#    5. draw the spaceship
#    6. generate health items
#    7. generate bonus point item
#    8. check for collisions with asteroids or items
#    9. update health bar and score if collision is found
#   10. increase and update score (you get points for surviving once game loop)
#   11. repeat
#
# Each step is a wrapper which calls the inner logic of performing 
# the tasks before jumping to the next task wrapper.
#  

# Start of the game loop
game_loop:
	jal update_difficulty # updates the difficulty if needed
	
	# delaying the loop to create animated effect
	li $v0, 32
	la $a0, ($t2)
	syscall
	
	# displaying the current score
	li $a2, BLACK
	jal write_current_score
	jal increase_score
	li $a2, DARK_GREY
	jal write_current_score

	j draw_asteroids_wrapper # drawing the asteroids

# writes the current score on the bottom right corner of the screen
write_current_score:
	addi $sp, $sp, -4
 	sw $ra, 0($sp) # push $ra onto stack

	la $t0, game_info
	lw $t0, 12($t0) # grabbing the current score

	div $t0, $t0, 1000
	mflo $a0
	mfhi $t0
	addi $a1, $s0, 3376
	jal write_number # writing the first digit
	
	div $t0, $t0, 100
	mflo $a0
	mfhi $t0
	addi $a1, $a1, 20
	jal write_number # writing the second digit
	
	div $t0, $t0, 10
	mflo $a0
	addi $a1, $a1, 20
	jal write_number # writing the third digit
	
	mfhi $a0
	addi $a1, $a1, 20
	jal write_number # writing the fourth digit
	
	lw $ra, 0($sp)
 	addi $sp, $sp, 4 # popping the return address of the stack
 	
 	jr $ra

# sets the game difficulty to the appropriate level
update_difficulty:
	la $t0, game_info
	lw $t1, 12($t0) # getting the current score
	lw $t2, 0($t0) # getting the current game speed
	
	# checking if the score matches the difficulties
	bgt $t1, LEVEL3, difficulty_3
	bgt $t1, LEVEL2, difficulty_2
	bgt $t1, LEVEL1, difficulty_1
	jr $ra

# draws the asteroids' new position
draw_asteroids_wrapper:
	la $t0, asteroids # location of asteroid array
	la $v1, game_info
	lw $v1, 0($v1)
	
	# the jal functions are to overwrite the current position,
	# move the asteroid one left, and draw the new position
	
	lw $a0, 0($t0) # ateroid type
	lw $a1, 4($t0) # asteroid current x position
	lw $a2, 8($t0) # asteroid current y position
	li $a3, 0 # first asteroid
	jal remove_asteroids_select
	jal asteroid_move_left
	jal draw_asteroids_select
	
	bgt $v1, SPEED1, draw_items_wrapper
	lw $a0, 12($t0) # ateroid type
	lw $a1, 16($t0) # asteroid current x position
	lw $a2, 20($t0) # asteroid current y position
	li $a3, 3 # second asteroid
	jal remove_asteroids_select
	jal asteroid_move_left
	jal draw_asteroids_select
	
	bgt $v1, SPEED2, draw_items_wrapper
	lw $a0, 24($t0) # ateroid type
	lw $a1, 28($t0) # asteroid current x position
	lw $a2, 32($t0) # asteroid current y position
	li $a3, 6 # third asteroid
	jal remove_asteroids_select
	jal asteroid_move_left
	jal draw_asteroids_select
	
	j draw_items_wrapper

# draws randomized items
draw_items_wrapper:
	la $a0, health_item1
	jal draw_health_item
	
	la $a0, health_item2
	jal draw_health_item
	
	la $a0, point_item
	jal draw_point_item

	j draw_ss_wrapper

# draws the spaceship's new position
draw_ss_wrapper:
	la $t0, ss_shift
	lw $t0, 8($t0)
	
	#beqz $t0, check_collision_wrapper
	
	la $a0, BLACK
	la $a1, BLACK
	jal draw_ss # overwriting the old position in black

	la $t0, ss_shift
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0) # resetting the shift amount array
	
	la $t0, ss_pixel
	lw $t3, 0($t0)
	add $t3, $t3, $t1
	sw $t3, 0($t0) # updating the x position of the spaceship
	
	lw $t3, 4($t0)
	add $t3, $t3, $t2
	sw $t3, 4($t0) # updating the y position of the spaceship

	la $t0, ss_color
	lw $a0, 0($t0)
	lw $a1, 4($t0)
	jal draw_ss # drawing the spaceship's new position
	
	j check_item_collected_wrapper
	
# checks if the spaceship collected any items
check_item_collected_wrapper:
	move $s4, $zero # initializing $s4, which will indicate if an item was collected
	la $a0, health_item1
	jal check_health_item_selector
	bnez $s4, increase_health
	la $a0, health_item2
	jal check_health_item_selector
	bnez $s4, increase_health
	la $a0, point_item
	jal check_point_item_collected
	bnez $s4, increase_points_from_item
	
	j gen_health_wrapper
	
# generates health items if there is a spot available	
gen_health_wrapper:
	# generating a random number between 0 and HEALTH_GEN_RATE and seeing if its equal to 0 (slow spawn rate)
	li $v0, 42
	li $a0, 0
	li $a1, HEALTH_GEN_RATE
	syscall
	
	bne $a0, $zero, gen_point_item_wrapper 
	
	# Checking if health_item1 is available to store the new health item
	la $t0, health_item1
	lw $t0, 0($t0)
	beq $t0, -1, gen_health_item1
	
	# Checking if health_item2 is available to store the new health item
	la $t0, health_item2
	lw $t0, 0($t0)
	beq $t0, -1, gen_health_item2

	# No available spots to store the new health item, so the generation is cancelled
	j gen_point_item_wrapper

# generates point bonus item
gen_point_item_wrapper:
	# Checking if there is a spot available to store the new point bonus item
	la $t0, point_item
	lw $t1, 0($t0)

	bne $t1, -1, check_collision_wrapper

	# generating a random number between 0 and POINT_GEN_RATE and seeing if its equal to 0 (slow spawn rate)
	li $v0, 42
	li $a0, 0
	li $a1, POINT_GEN_RATE
	syscall
	
	bne $a0, $zero, check_collision_wrapper
	
	li $v0, 4
	la $a0, print_item
	syscall 
	
	# Generating a random y-coord for the new point bonus item
	li $v0, 42
	li $a0, 0
	li $a1, 13
	syscall
	addi $a0, $a0, 8
	
	# Storign the newly generating point bonus item to be drawn onto the screen
	sw $a0, 8($t0)
	li $a0, 30
	sw $a0, 4($t0)
	li $a0, 3
	sw $a0, 0($t0)

	j check_collision_wrapper
	
# checks for any collisions between the spaceship and asteroid		
check_collision_wrapper:
	li $t0, ENABLE_COLLISIONS
	beqz $t0, check_keypress_wrapper 

	#j check_keypress_wrapper
	la $s4, ($zero) # initializing $s4, which will indicate if a collision was found
	la $v1, game_info
	lw $v1, 0($v1)

	li $a0, 0
	jal check_collision_asteroid # checking if a collision with asteroid 1 occured
	bgtz $s4, ss_collided # if a collision with asteroid 1 was found, exit early
	
	bgt $v1, SPEED1, check_keypress_wrapper
	li $a0, 12
	jal check_collision_asteroid # checking if a collision with asteroid 2 occured
	bgtz $s4, ss_collided # if a collision with asteroid 2 was found, exit early
	
	bgt $v1, SPEED2, check_keypress_wrapper
	li $a0, 24
	jal check_collision_asteroid # checking if a collision with asteroid 3 occured
	bgtz $s4, ss_collided # if a collision with asteroid 3 was found, exit early
	
	j check_keypress_wrapper # no collision was found, so move to the next loop check

# checks for gameplay keypresses
check_keypress_wrapper:
	jal check_keypress # checking if a key was pressed
	j end_of_game_loop

# any miscellaneous game loop checks go here 
end_of_game_loop:
	jal clear_display_buffer
	jal check_konami_cc
	j game_loop

# Checks if the user entered the correct cheat code
check_konami_cc:
	la $t0, konami_cc # storing the address of the konami stack
	lw $t1, 0($t0)
	bne $t1, 98, quick_return # checking if the first item of the stack is B
	lw $t1, 4($t0)
	bne $t1, 100, quick_return # checking if the second item of the stack is D
	lw $t1, 8($t0)
	bne $t1, 97, quick_return # checking if the third item of the stack is A
	lw $t1, 12($t0)
	bne $t1, 115, quick_return # checking if the fourth item of the stack is S
	lw $t1, 16($t0)
	bne $t1, 119, quick_return # checking if the fifth item of the stack is W
	
	li $v0, 4
	la $a0, print_konami
	syscall
	
	# Resetting the konami stack
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	sw $zero, 12($t0)
	sw $zero, 16($t0)
	
	# Updating the color of the spaceship to the special color
	la $t0, ss_color
	li $t1, SS_KONAMI
	sw $t1, 0($t0)
	li $t1, WHITE
	sw $t1, 4($t0)
	
	jr $ra

# resolves pick-up items glitch
clear_display_buffer:
	li $a0, 512
	li $a1, 3712
	li $a2, BLACK
	j draw_vertical_line
									
#-------------------------------------------------#	
#    BELOW CONTAINS THE MAIN LOGIC OF THE GAME    #
#-------------------------------------------------#
# increases the player score and caps it at 9999 (cant display more than 4 digits)
increase_score:
	la $t0, game_info
	lw $t1, 12($t0)
	
	addi $t1, $t1, SCORE_INCREASE
	sw $t1, 12($t0)
	
	ble $t1, 9999, quick_return
	li $t1, 9999
	sw $t1, 12($t0)
	
	jr $ra

# decreases the player score
decrease_score:
	la $t0, game_info
	lw $t1, 12($t0)
	
	blt $t1, $a0, set_min_score # checking if the points lost is greater than the current points (prevents negative points)
	
	sub $t1, $t1, $a0
	sw $t1, 12($t0) # subtracting the points lost and storing it back in the game info array
	
	jr $ra
	
# decreases the player health	
decrease_health:
	la $a0, game_info # a0 is preserved for the decrease_health_bar function
	lw $t1, 4($a0) # stores the current health
	sub $t1, $t1, $s4 # decreases the current health ($s4, contains the amount to decrease by)
	sw $t1, 4($a0) # storing the new health back in the game info array
	
	jr $ra
	
# sets the score to zero
set_min_score:
	sw $zero, 12($t0)
	jr $ra

# sets the game difficulty to level 1
difficulty_1:
	beq $t2, SPEED1, quick_return # checking if a level update is necessary
	li $t2, SPEED1
	sw $t2, 0($t0) 
	
	li $t3, LIGHT_BLUE
	sw $t3, 3844($s0)
	sw $t3, 3848($s0) # drawing the level indicator
	
	li $v0, 4
	la $a0, print_du
	syscall 
	
	jr $ra

# sets the game difficulty to level 2
difficulty_2:
	beq $t2, SPEED2, quick_return # checking if a level update is necessary
	li $t2, SPEED2
	sw $t2, 0($t0)
	
	li $t3, LIGHT_BLUE
	sw $t3, 3856($s0)
	sw $t3, 3860($s0) # drawing the level indicator
	
	li $v0, 4
	la $a0, print_du
	syscall 
	
	jr $ra

# sets the game difficulty to level 3
difficulty_3:
	beq $t2, SPEED3, quick_return # checking if a level update is necessary
	li $t2, SPEED3
	sw $t2, 0($t0)
	
	li $t3, LIGHT_BLUE
	sw $t3, 3868($s0)
	sw $t3, 3872($s0) # drawing the level indicator
	
	li $v0, 4
	la $a0, print_du
	syscall 
	
	jr $ra
	
draw_health_item:
	lw $t0, 0($a0)
	beq $t0, 1, draw_health_item1
	j draw_health_item2
	
# clears an item's information
clear_item:
	li $t1, -1
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	
	jr $ra
	
# increases the score from picking up an item
# the amount to increase the score by is in $s4
increase_points_from_item:
	li $a2, BLACK
	jal write_current_score
	la $t0, game_info
	lw $t1, 12($t0)
	add $t1, $t1, $s4
	sw $t1, 12($t0)
	ble $t1, 9999, update_score_board
	li $t1, 9999
	sw $t1, 12($t0)
	j update_score_board

# updates on-screen score after picking up a health item	
update_score_board:
	li $a2, LIGHT_BLUE
	jal write_current_score # writing the score in a light blue to indicate point gain
	
	la $t0, ss_color
	la $a0, DARK_BLUE
	lw $a1, 4($t0)
	jal draw_ss # drawing spaceship in dark blue to indicate item was collected
	
	li $v0, 32
	li $a0, ITEM_PICKUP_DELAY
	syscall # slightly delaying the game to further indicate a point gain has occured
	
	j gen_health_wrapper

# Checks if the point bonus item was collected
check_point_item_collected:	
	lw $t0, 0($a0)
	beq $t0, -1, quick_return
	
	lw $t0, 4($a0) # x coord of item
	lw $t1, 8($a0) # y coord of item
	
	la $a1, ss_pixel
	lw $t2, 0($a1) # x coord of spaceship
	lw $t3, 4($a1) # y coord of spaceship
	
	blt $t0, $t2, quick_return # item is behind spaceship

	sll $t6, $t1, 5
	add $t6, $t6, $t0
	sll $t6, $t6, 2 # t6 contains item offset
	move $t8, $t6
	
	sll $t7, $t3, 5
	add $t7, $t7, $t2
	sll $t7, $t7, 2 # t6 contains spaceship offset
	
	# Checking if the significant coordinates overlap between the spaceship and item
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 124
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	
	move $t6, $t8
	addi $t7, $t7, 132 # next pixel on spaceship to check
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 124
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	
	move $t6, $t8
	addi $t7, $t7, 132 # next pixel on spaceship to check
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 124
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	
	move $t6, $t8
	addi $t7, $t7, 124 # next pixel on spaceship to check
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 124
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	
	move $t6, $t8
	addi $t7, $t7, 124 # next pixel on spaceship to check
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 124
	beq $t6, $t7, collected_point_item
	addi $t6, $t6, 4
	beq $t6, $t7, collected_point_item
	
	jr $ra

# This is called if a bonus point item was collected
collected_point_item:
	sll $t6, $t1, 5
	add $t6, $t6, $t0
	sll $t6, $t6, 2 # t6 contains item offset
	add $t6, $t6, $s0 # t6 contains item offset + base address
	
	# Removing the bonus point item from the screen
	li $t4, BLACK
	sw $t4, 0($t6)
	sw $t4, 4($t6)
	sw $t4, 128($t6)
	sw $t4, 132($t6)
	
	# Generating a random point increase
	li $v0, 42
	li $a0, 0
	li $a1, POINT_GAIN_ADDITIONAL
	syscall
	addi $s4, $a0, POINT_GAIN_BASE
	
	la $a0, point_item
	j clear_item
	
# Increasing the player health	
increase_health:
	la $t0, game_info
	lw $t1, 4($t0)
	
	add $t1, $t1, $s4
	sw $t1, 4($t0)
	
	ble $t1, START_HEALTH, increase_health_bar
	li $t1, START_HEALTH
	sw $t1, 4($t0)

	j increase_health_bar

# Increasing the health bar
increase_health_bar:
	subi $t1, $t1, 1
	sll $t1, $t1, 2
	addi $t1, $t1, HEALTH_BAR_START
	sw $t1, 8($t0)

	jal draw_health_bar
	
	la $t0, ss_color
	la $a0, GREEN
	lw $a1, 4($t0)
	jal draw_ss # drawing the spaceship in green to indicate health gain
	
	li $v0, 32
	li $a0, ITEM_PICKUP_DELAY
	syscall # slightly delaying the game to further indicate a health gain has occured
	
	j gen_health_wrapper
	
# Checking if any of the health bonus items were collected
check_health_item_selector:
	lw $t0, 0($a0)
	beq $t0, -1, quick_return
	
	lw $t1, 4($a0) # x coord of health item
	lw $t2, 8($a0) # y coord of health item
	la $t3, ss_pixel
	lw $t4, 0($t3) # x coord of spaceship
	lw $t5, 4($t3) # y coord of spaceship
	
	beq $t0, 1, health_item1_collision
	j health_item2_collision

# Checking for a collision with the smaller health item (the yellow one)
health_item1_collision:
	blt $t1, $t4, quick_return # health item is behind spaceship

	sll $t6, $t2, 5
	add $t6, $t6, $t1
	sll $t6, $t6, 2
	
	sll $t7, $t5, 5
	add $t7, $t7, $t4
	sll $t7, $t7, 2
	
	beq $t6, $t7, item_collected1
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected1
	subi $t6, $t6, 128
	
	addi $t7, $t7, 256
	beq $t6, $t7, item_collected1
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected1
	subi $t6, $t6, 128
	
	addi $t7, $t7, 8
	beq $t6, $t7, item_collected1
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected1
	subi $t6, $t6, 128
	
	addi $t7, $t7, 248
	beq $t6, $t7, item_collected1
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected1

	jr $ra

# Checking for a collision with the larger health item (the red one)	
health_item2_collision:	
	blt $t1, $t4, quick_return # health item is behind spaceship

	sll $t6, $t2, 5
	add $t6, $t6, $t1
	sll $t6, $t6, 2
	
	sll $t7, $t5, 5
	add $t7, $t7, $t4
	sll $t7, $t7, 2
	
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	subi $t6, $t6, 256
	
	addi $t7, $t7, 256
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	subi $t6, $t6, 256
	
	addi $t7, $t7, 8
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	subi $t6, $t6, 256
	
	addi $t7, $t7, 248
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2
	addi $t6, $t6, 128
	beq $t6, $t7, item_collected2

	jr $ra

# Removing the smaller health item from the screen if collected
item_collected1:
	sll $t6, $t2, 5
	add $t6, $t6, $t1
	sll $t6, $t6, 2 # t6 contains item offset
	add $t6, $t6, $s0 # offset + base address
	
	li $t5, BLACK
	sw $t5, 0($t6)
	sw $t5, 4($t6)
	sw $t5, 128($t6)
	sw $t5, 132($t6)
	
	li $s4, 4
	
	j clear_item

# Removing the larger health itme from the screen if collected
item_collected2:
	sll $t5, $t2, 5
	add $t5, $t5, $t1
	sll $t5, $t5, 2
	add $t5, $t5, $s0
	
	li $t4, BLACK
	sw $t4, 4($t5)
	sw $t4, 8($t5)
	sw $t4, 128($t5)
	sw $t4, 132($t5)
	sw $t4, 136($t5)
	sw $t4, 256($t5)
	sw $t4, 260($t5)
	sw $t4, 264($t5)
	
	li $s4, 12
	
	j clear_item

# Generating the first health item
gen_health_item1:
	jal generate_item
	
	la $t3, health_item1
	sw $t1, 0($t3)
	li $t1, 30
	sw $t1, 4($t3)
	sw $t0, 8($t3)
	
	li $v0, 4
	la $a0, print_gain4
	syscall 
	
	j gen_point_item_wrapper

# Generating the second health item
gen_health_item2:
	jal generate_item

	la $t3, health_item2
	sw $t1, 0($t3)
	li $t1, 30
	sw $t1, 4($t3)
	sw $t0, 8($t3)
	
	la $a0, health_item1
	jal draw_health_item
	
	li $v0, 4
	la $a0, print_gain4
	syscall 
	
	j gen_point_item_wrapper

# generates item type and y-position for a health item stored in t1 and t0 respectively
generate_item:
	li $v0, 42
	li $a0, 0
	li $a1, 13
	syscall
	
	addi $t0, $a0, 8 # randomly generated y coordinate
	li $t1, 2
	
	li $v0, 42
	li $a0, 0
	li $a1, 4
	syscall
	
	beq $a0, 1, quick_return
	li $t1, 1
	jr $ra
																					
# this function is called when a spaceship-asteroid collision is detected, it updates the points, health and spaceship status												
ss_collided:
	la $t0, ss_color
	la $a0, SS_COLOR3
	lw $a1, 4($t0)
	jal draw_ss # drawing the spaceship in red to indicate a collision
	
	# writing the new score in the bottom write corner of the display
	li $a2, BLACK
	jal write_current_score
	
	li $t0, SCORE_DECREASE
	mult $t0, $s4
	mflo $a0 # decreasing the score -> SCORE_DECREASE * ASTEROID SIZE
	jal decrease_score
	
	li $a2, DARK_GREY
	jal write_current_score
	
	jal decrease_health # decreasing the player health ($s4 is preserved to indicate how much to decrease by)
	
	move $a1, $s4 # storing the number of columns to remove from the health bar in $a1
	jal decrease_health_bar # decreasing the health bar ($a1 is a parameter which indicates how much to decrease by from $s4)
	jal draw_health_bar  # drawing the new health bar (it has three stages: green, yellow, red)
	
	li $v0, 32
	li $a0, ITEM_PICKUP_DELAY
	syscall # slightly delaying the game to further indicate a collision has occured
	
	j check_keypress_wrapper
	
# decreases the health bar by the amount indicated in $a1
decrease_health_bar:
	# $a0 stores the address of the game info array, which was preserved from decrease_health
	lw $t0, 8($a0) # storing the offset of the end of the health bar
	add $t1, $t0, $s0 # add the offset of the health bar to the base address
	
	la $t2, BLACK
	sw $t2, 0($t1)
	sw $t2, 128($t1) # filling in the last column of the health bar with black
	
	subi $a1, $a1, 1
	subi $t0, $t0, 4
	sw $t0, 8($a0) # decreasing the offset of the end of the health bar, as it has been lowered

	blt $t0, HEALTH_BAR_START, gameover # checking if the player has no health remaining

	bgtz $a1, decrease_health_bar # checking if there are more columns to overwrite
	jr $ra
	
# checks for asteroid collisions based on the asteroid type
check_collision_asteroid:
	la $t0, asteroids
	add $t0, $t0, $a0 # getting the current asteroid

	lw $t1, 0($t0) # storing the type of asteroid we are dealing with
	lw $t2, 4($t0) # storing the x position of the asteroid
	lw $t3, 8($t0) # storing the y position of the asteroid
	
	mult $t3, $s1
	mflo $a1
	add $a1, $a1, $t2 # a1 contains asteroid 1's location by its offset
	
	la $t0, ss_pixel
	lw $t2, 0($t0) # storing the x position of the spaceship
	lw $t3, 4($t0) # storing the y position of the spaceship
	
	mult $t3, $s1
	mflo $a0
	add $a0, $a0, $t2 # a0 contains the spaceship's location by its offset
	
	# checking which asteroid type to check for collision with
	beqz $t1, check_collision_type0 
	beq $t1, 1, check_collision_type1
	j check_collision_type2
	
# THE FOLLOWING 3 LABELS CHECK FOR SPACESHIP-ASTEROID COLLISION BY COMPARING THEIR OFFSET
# checks for spaceship collision with the largest asteroid
check_collision_type0:
	la $t0, ($a1)
	addi $t1, $t0, 32
	addi $t2, $t1, 32
	addi $t3, $t2, 33

	beq $a0, $t0, collision_detected3
	beq $a0, $t1, collision_detected3
	beq $a0, $t2, collision_detected3
	beq $a0, $t3, collision_detected3
	
	addi $a0, $a0, 31
	beq $a0, $t0, collision_detected3
	beq $a0, $t1, collision_detected3
	beq $a0, $t2, collision_detected3
	beq $a0, $t3, collision_detected3
	
	addi $a0, $a0, 35
	beq $a0, $t0, collision_detected3
	beq $a0, $t1, collision_detected3
	beq $a0, $t2, collision_detected3
	beq $a0, $t3, collision_detected3
	
	addi $a0, $a0, 29
	beq $a0, $t0, collision_detected3
	beq $a0, $t1, collision_detected3
	beq $a0, $t2, collision_detected3
	beq $a0, $t3, collision_detected3
	
	addi $a0, $a0, 33
	beq $a0, $t0, collision_detected3
	beq $a0, $t1, collision_detected3
	beq $a0, $t2, collision_detected3
	beq $a0, $t3, collision_detected3
	
	jr $ra

# checks for spaceship collision with the medium asteroid
check_collision_type1:
	la $t0, ($a1)
	addi $t1, $t0, 32
	addi $t2, $t1, 33

	beq $a0, $t0, collision_detected2
	beq $a0, $t1, collision_detected2
	beq $a0, $t2, collision_detected2
	
	addi $a0, $a0, 31
	beq $a0, $t0, collision_detected2
	beq $a0, $t1, collision_detected2
	beq $a0, $t2, collision_detected2
	
	addi $a0, $a0, 35
	beq $a0, $t0, collision_detected2
	beq $a0, $t1, collision_detected2
	beq $a0, $t2, collision_detected2
	
	addi $a0, $a0, 29
	beq $a0, $t0, collision_detected2
	beq $a0, $t1, collision_detected2
	beq $a0, $t2, collision_detected2
	
	addi $a0, $a0, 33
	beq $a0, $t0, collision_detected2
	beq $a0, $t1, collision_detected2
	beq $a0, $t2, collision_detected2

	jr $ra

# checks for spaceship collision with the smallest asteroid
check_collision_type2:
	la $t0, ($a1)
	addi $t1, $t0, 32

	beq $a0, $t0, collision_detected1
	beq $a0, $t1, collision_detected1
	
	addi $a0, $a0, 31
	beq $a0, $t0, collision_detected1
	beq $a0, $t1, collision_detected1
	
	addi $a0, $a0, 35
	beq $a0, $t0, collision_detected1
	beq $a0, $t1, collision_detected1
	
	addi $a0, $a0, 29
	beq $a0, $t0, collision_detected1
	beq $a0, $t1, collision_detected1
	
	addi $a0, $a0, 33
	beq $a0, $t0, collision_detected1
	beq $a0, $t1, collision_detected1

	jr $ra

# THE FOLLOWING 3 LABELS MARK A COLLISION HAS BEEN DETECTED BY STORING A NON-ZERO NUMBER IN $s4 INDICATING THE ASTEROID TYPE
collision_detected1:
	li $s4, 1
	jr $ra
	
collision_detected2:
	li $s4, 2
	jr $ra
	
collision_detected3:
	li $s4, 3
	jr $ra

# removes an asteroid from the display
remove_asteroids_select:
	# setting the outline and inner colors to overwrite the asteroid with black
	li $s6, BLACK
	li $s7, BLACK
	
	# checking the asteroid type to be overwritten
	beq $a0, $zero, draw_asteroid_2
	beq $a0, 1, draw_asteroid_1
	j draw_asteroid_0

# draws an asteroid on the display
draw_asteroids_select:
	# setting the outline and inner colors of the asteroid
	li $s6, ASTEROID_COLOR1
	li $s7, ASTEROID_COLOR2

	# checking the asteroid type to be drawn
	beq $a0, $zero, draw_asteroid_2
	beq $a0, 1, draw_asteroid_1
	j draw_asteroid_0

# moves an asteroid to the left by either 1,2, or 3 pixels according to their type
asteroid_move_left:
	sub $a1, $a1, $a0
	subi $a1, $a1, 1 # moving the x position of the asteroid one left
	
	ble $a1, -1, asteroid_regen # checking if the asteroid needs to be regenerated
	
	addi $a3, $a3, 1 # array index of the x position of the current asteroid
	
	# calculating offset of the array index
	li $t2, 4
	mult $a3, $t2
	mflo $t4
	
	# updating new x position of the asteroid after moving on left
	la $t2, asteroids 
	add $t4, $t4, $t2
	sw $a1, 0($t4) 
	
	jr $ra

# regenerates an asteroid that has reached the end of the display
asteroid_regen:
	la $t1, asteroids # getting location of the asteroids array
	
	# calculating offset of the current asteroid being regenerated
	li $t2, 4
	mult $a3, $t2
	mflo $t7
	add $t1, $t1, $t7 

	# generating a new asteroid type
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall
	la $t7, ($a0)
	sw $t7, 0($t1)
	
	# generating a new starting x position
	li $v0, 42
	li $a0, 0
	li $a1, 4
	syscall
	la $t8, ($a0)
	addi $t8, $t8, 34
	sw $t8, 4($t1)
	
	# generating a new starting y position
	li $v0, 42
	li $a0, 0
	li $a1, 21
	syscall
	la $t9, ($a0)
	addi $t9, $t9, 5
	sw $t9, 8($t1)
	
	# restoring the draw_ss function parameters with the newly generated ones
	la $a0, ($t7)
	la $a1, ($t8)
	la $a2, ($t9)
	
	jr $ra

# checks for key presses during gameplay
check_keypress:
	li $t9, MMIO_ADDRESS
	lw $t8, 0($t9)
	beq $t8, 1, detected_keypress # checking if a key was pressed
	
	jr $ra

# detects which key was pressed during gameplay
detected_keypress:
	lw $t2, 4($t9) # storing the key that got pressed, preserve it
	
	addi $sp, $sp, -4
 	sw $ra, 0($sp) # push $ra onto stack
 	
 	jal add_to_konami
 	
 	lw $ra, 0($sp) # pop $ra off stack
 	addi $sp, $sp, 4
	
	# checking if w,a,s,d,p, or e was pressed
	beq $t2, 0x77, keypress_w
	beq $t2, 0x61, keypress_a 
	beq $t2, 0x73, keypress_s 
	beq $t2, 0x64, keypress_d
	beq $t2, 0x70, game_init
	beq $t2, 0x65, exit    
	
	jr $ra

# Adds to the konami_cc stack
add_to_konami:
	la $t3, konami_cc
	
	lw $t4, 12($t3)
	sw $t4, 16($t3) # konami_cc[4] = konami_cc[3]
	lw $t4, 8($t3)
	sw $t4, 12($t3) # konami_cc[3] = konami_cc[2]
	lw $t4, 4($t3)
	sw $t4, 8($t3) # konami_cc[2] = konami_cc[1]
	lw $t4, 0($t3)
	sw $t4, 4($t3) # konami_cc[1] = konami_cc[0]
	sw $t2, 0($t3) # konami_cc[0] = key that just got pressed
	
	jr $ra

# THE FOLLOWING 4 LABLES MOVE THE SPACESHIP IN THEIR APPROPRIATE DIRECTION BASED ON WASD MOVEMENT
keypress_w:	
	la $t0, ss_pixel # start of the array which stores the spaceship's coordinates
	lw $t0, 4($t0) # y coordinate of the spaceship
	
	addi $t0, $t0, -1 # top-most pixel of the spaceship after moving one up
	
	blt $t0, 4, quick_return # checking if the top-most pixel is within the display
	li $t0, -1
	la $t1, ss_shift
	sw $t0, 4($t1) # updating the ss_shift array to indicate moving up
	
	li $t0, 1
	sw $t0, 8($t1) # updating the ss_shift to indicate movement has occured
	
	jr $ra

keypress_a:
	la $t0, ss_pixel # start of the array which stores the spaceship's coordinates
	lw $t0, 0($t0) # x coordinate of the spaceship
	
	addi $t0, $t0, -2 # left-most pixel of the spaceship after moving one left
	
	blez $t0, quick_return # checking if the left-most pixel is within the display
	li $t0, -1
	la $t1, ss_shift
	sw $t0, 0($t1) # updating the ss_shift array to indicate moving left
	
	li $t0, 1
	sw $t0, 8($t1) # updating the ss_shift to indicate movement has occured
	
	jr $ra

keypress_s:	
	la $t0, ss_pixel # start of the array which stores the spaceship's coordinates
	lw $t0, 4($t0) # y coordinate of the spaceship
	
	addi $t0, $t0, 5 # bottom-most pixel of the spaceship after moving one down
	
	bgt $t0, 29, quick_return # checking if the bottom-most pixel is within the display
	li $t0, 1
	la $t1, ss_shift
	sw $t0, 4($t1) # updating the ss_shift array to indicate moving down
	
	li $t0, 1
	sw $t0, 8($t1) # updating the ss_shift to indicate movement has occured
	
	jr $ra

keypress_d:
	la $t0, ss_pixel # start of the array which stores the spaceship's coordinates
	lw $t0, 0($t0) # x coordinate of the spaceship
	
	addi $t0, $t0, 3 # right-most pixel of the spaceship after moving one right
	
	bge $t0, WIDTH, quick_return # checking if the right-most pixel is within the display
	li $t0, 1
	la $t1, ss_shift
	sw $t0, 0($t1) # updating the ss_shift array to indicate moving right
	
	li $t0, 1
	sw $t0, 8($t1) # updating the ss_shift to indicate movement has occured
	
	jr $ra

#---------------------------------------------------------------------------#
#            THE FOLLOWING LABELS CONTAIN LOGIC FOR THE AFTER GAME          #
#---------------------------------------------------------------------------#
# displays the gameover screen
gameover:
	jal print_total_time_elapsed

	li $v0, 32
	li $a0, DEATH_DELAY
	syscall # delaying the death to indicate the player has lost

	jal wipe_screen_wrapper # clearing the screen
	jal get_score # grabbing the player score

	jal write_gameover # writing "GAMEOVER!"
	
	li $a0, 2192
	li $a1, 2284
	jal write_lines_wrapper # drawing the upper line
	
	li $a0, 3472
	li $a1, 3564
	jal write_lines_wrapper # drawing the lower line
	
	jal print_final_score
	
	# Writing the score on the display
	# The method used extracts each digit separately to be drawn by applying modulus in powers of 10
	div $s7, $s6, 1000
	mflo $a0
	mfhi $s7
	addi $a1, $s0, 2588
	li $a2, LIGHT_BLUE
	jal write_number
	
	div $s7, $s7, 100
	mflo $a0
	mfhi $s7
	addi $a1, $s0, 2608
	jal write_number
	
	div $s7, $s7, 10
	mflo $a0
	addi $a1, $s0, 2628
	jal write_number
	
	mfhi $a0
	add $a1, $s0, 2648
	jal write_number
	
	li $v0, 32
	li $a0, GAMEOVER_DELAY
	syscall # keeping the gameover screen displayed for the duration of GAMEOVER_DELAY

	j get_highscores

print_final_score:
	li $v0, 4
	la $a0, print_finalscore
	syscall 
	
	li $v0, 1
	move $a0, $s6
	syscall
	
	li $v0, 4
	la $a0, print_newline
	syscall 
	
	jr $ra

# prints the total time elapsed for the game
print_total_time_elapsed:
	li $v0, 30
	syscall # getting the end time to calculate total time elapsed
	
	la $t0, start_time
	lw $t0, 0($t0)
	
	sub $a0, $a0, $t0 # caclulating total time elapsed
	
	li $t0, 1000
	div $a0, $t0
	mflo $a1
	mfhi $t0
	
	li $v0, 4
	la $a0, print_timeelapsed
	syscall
	li $v0, 1
	move $a0, $a1
	syscall # print seconds
	li $v0, 4
	la $a0, print_period
	syscall # print decimal
	
	blt $t0, 10, time_with_two_zeros
	blt $t0, 100, time_with_one_zero
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, print_time
	syscall # displaying the total time elapsed
	
	jr $ra

# The bottom two labels print the time elapsed in the console
time_with_two_zeros:
	li $v0, 4
	la $a0, print_zero
	syscall # print first zero
	li $v0, 4
	la $a0, print_zero
	syscall # print second zerio
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, print_time
	syscall # displaying the total time elapsed
	jr $ra

time_with_one_zero:
	li $v0, 4
	la $a0, print_zero
	syscall # print first zero
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, print_time
	syscall # displaying the total time elapsed
	jr $ra

# grabs the highscores from the highscore file
get_highscores:
	li $v0, 13
	la $a0, hs_filename
	li $a1, 0
	syscall
	move $s5, $v0 # open file for reading
	
	li $v0, 14
	move $a0, $s5
	la $a1, hs_content # storing the highscores in hs_content
	la $a2, 12
	syscall # read from file
	
	li $v0, 16
	move $a0, $s5
	syscall # close file

	j compare_highscores

# checking if a highscore was acheived (ie. coming in top 3 all-time)
compare_highscores:
	# converting the three highscores into 4 byte integers
	li $a0, 0
	jal bytetoint
	move $t0, $v0
	
	li $a0, 4
	jal bytetoint
	move $t1, $v0
	
	li $a0, 8
	jal bytetoint
	move $t2, $v0

	# t0, t1, t2 contain the current highscores
	# s6 contains the player score
	# preserve t0,t1,t2,s6
	
	jal sort_scores # stores the top 3 highscores in t0, t1, and t2 respectively in decreasing order
	move $v1, $v0 # $v0 indicates if a highscore was achieved
	
	# pushing the highscores onto the stack to be displayed in later screen
	addi $sp, $sp, -4
 	sw $t2, 0($sp) # push third hs onto stack
 	addi $sp, $sp, -4
 	sw $t1, 0($sp) # push second hs onto stack
 	addi $sp, $sp, -4
 	sw $t0, 0($sp) # push first hs onto stack
	
	beqz $v1, display_highscores # checking if a highscore was achieved
	
	# since a highscore was achieved, the following code stores the new highscores in decreasing order in hs_content 
	# they will be to be written into the highscore file
	li $a0, 0
	move $a1, $t0
	jal set_hs_content
	
	li $a0, 4
	move $a1, $t1
	jal set_hs_content
	
	li $a0, 8
	move $a1, $t2
	jal set_hs_content
	
	jal write_to_hsfile # writing the new highscore list into the highscore file
	
	jal wipe_screen_wrapper # clearing the screen
	j display_new_highscore 

# shows the user that they hit a highscore
display_new_highscore:
	jal write_new_hs # writing the words "HIGH-SCORE!"

	li $a0, 2192
	li $a1, 2284
	jal write_lines_wrapper # drawing the upper line
	
	li $a0, 3472
	li $a1, 3564
	jal write_lines_wrapper # drawing the lower line
	
	j flash_new_hs_wrapper

# flashes the highscore between black and blue to make it obvious an achievement was earned
flash_new_hs_wrapper:
	# storing the individual digits in t1,t2,t3, and t4 by applying modulus in powers of 10
	div $s7, $s6, 1000
	mflo $t1
	mfhi $s7
	div $s7, $s7, 100
	mflo $t2
	mfhi $s7
	div $s7, $s7, 10
	mflo $t3
	mfhi $t4

	li $t0, 6 # indicates how many times to flash the score
	li $t6, LIGHT_BLUE # indicates the color of the text
	li $a3, 2588 # indicates the starting offset of the text
	li $t5, 0 # indicates where to jump after flashing
	j flash_new_hs

# drawing the highscore flashes
flash_new_hs:
	beqz $t0, finish_flash # checking if the number of flashes has been reached
	subi $t0, $t0, 1 # subtract one from the counter

	# writing each digit
	move $a0, $t1
	add $a1, $s0, $a3
	move $a2, $t6
	jal write_number
	
	move $a0, $t2
	addi $a1, $a1, 20
	jal write_number
	
	move $a0, $t3
	addi $a1, $a1, 20
	jal write_number
	
	move $a0, $t4
	addi $a1, $a1, 20
	jal write_number
	
	jal check_skip_hsflash
	
	li $v0, 32
	li $a0, 400
	syscall # sleeping for 0.4s to simulate flashing
	
	# removing each digit from the screen
	move $a0, $t1
	add $a1, $s0, $a3
	jal remove_number
	
	move $a0, $t2
	addi $a1, $a1, 20
	jal remove_number
	
	move $a0, $t3
	addi $a1, $a1, 20
	jal remove_number
	
	move $a0, $t4
	addi $a1, $a1, 20
	jal remove_number
	
	jal check_skip_hsflash
	
	li $v0, 32
	li $a0, 400
	syscall # sleeping for 0.4s to simulate flashing
	
	j flash_new_hs

# checking if a key was pressed while flashing a hs
check_skip_hsflash:
	li $t9, MMIO_ADDRESS
	lw $t8, 0($t9)
	beq $t8, 1, check_can_skipflash
	jr $ra
	
# checks if the 'a' key was pressed, indicating the user wants to skip watching the hs flash	
check_can_skipflash:
	lw $t8, 4($t9) # storing the key that got pressed
	beq $t8, 0x61, finish_flash # checking if the key pressed was a
	jr $ra

# this function is called after a flash is finished
# $t5 indicates where to jump next -> a non-zero value means its time to go back to the start screen
finish_flash:
	beqz $t5, display_highscores # t5 is equal to 0 only when a highscore is achieved, so the highscore list still needs to be displayed
	j start_screen

# displayes the list of all-time highscores
display_highscores:
	jal wipe_screen_wrapper # clearing the screen
	
	jal write_hs_list # writing "HS.LIST"
	
	li $a0, 1036
	li $a1, 1136
	jal write_lines_wrapper # underlining "HS.LIST"
	
	# Writing the first highscore
	li $a3, 1436
	jal draw_highscore
	
	# Writing the second highscore
	li $a3, 2332
	jal draw_highscore
	
	# Writing the third highscore
	li $a3, 3228
	jal draw_highscore
	
	# v1 indicates whether a highscore was achieved
	# if it was achieved, then you need to flash the highscore to show the player where they rank
	bgtz $v1, flash_new_hslist 

	li $a1, 0
	j hs_screen_time

hs_screen_time:
	bgt $a1, SHOW_HS_DELAY, start_screen
	addi $a1, $a1, 100
	
	jal check_skip_hslist
	
	li $v0, 32
	li $a0, 100
	syscall 
	
	j hs_screen_time
	
# checking if a key was pressed in the highscore screen
check_skip_hslist:
	li $t9, MMIO_ADDRESS
	lw $t8, 0($t9)
	beq $t8, 1, check_can_skip_hslist
	jr $ra
	
# checks if the 'a' key was pressed, indicating the user wants to skip viewing the hs
check_can_skip_hslist:
	lw $t8, 4($t9) # storing the key that got pressed
	beq $t8, 0x61, start_screen # checking if the key pressed was a
	jr $ra

# this function flashes the new highscore on the all-time highscore list to show the player where they rank all-time
flash_new_hslist:
	# storing the digits of the new highscore in t1,t2,t3, and t4 by applying modulus in powers of 10
	div $s7, $s6, 1000
	mflo $t1
	mfhi $s7
	div $s7, $s7, 100
	mflo $t2
	mfhi $s7
	div $s7, $s7, 10
	mflo $t3
	mfhi $t4
	
	li $a3, 896 # the offset of 7 rows in the display (its the distance between each highscore listed)
	mult $a3, $v1
	mflo $a3 # multying the offset by the position of the new highscore within the highscores list (v1 contains this information)
	addi $a3, $a3, 540 # adding the offset to the starting position of the highscore list (this is the offset of the highscore to be flashed)
	li $t0, 14 # indicates how many times to flash the new highscore in the highscore list
	li $t5, 1 # indicates the type of jump to make when calling finish_flash
	li $t6, YELLOW # indicates the color of the text
	j flash_new_hs

# draws one highscore onto the screen
# a3 stores the offset of the starting position to draw from
draw_highscore:
	lw $t0, 0($sp) # pop the current hs off stack
 	addi $sp, $sp, 4

	addi $sp, $sp, -4
 	sw $ra, 0($sp) # push $ra onto stack to make the nested function calls

	# drawing each digit individually by applying modulus in powers of 10
	div $s7, $t0, 1000
	mflo $a0
	mfhi $s7
	add $a1, $s0, $a3
	li $a2, WHITE
	jal write_number
	
	div $s7, $s7, 100
	mflo $a0
	mfhi $s7
	addi $a1, $a1, 20
	jal write_number
	
	div $s7, $s7, 10
	mflo $a0
	addi $a1, $a1, 20
	jal write_number
	
	mfhi $a0
	addi $a1, $a1, 20
	jal write_number
	
	lw $ra, 0($sp)
 	addi $sp, $sp, 4 # popping the return address of the outer function
 	
 	jr $ra

# writes highscores to the highscore file
write_to_hsfile:
	li $v0, 13
	la $a0, hs_filename
	li $a1, 1
	syscall
	move $s5, $v0 # open file for writing
	
	li $v0, 15   
 	move $a0, $s5   
  	la $a1, hs_content   # writing hs_content into the highscore file
  	li $a2, 12       # the highscore format is 12 consecutive digits, or 12 bytes
  	syscall
	
	li $v0, 16
	move $a0, $s5
	syscall # close file

# sets a highscore into the hs_content array
# a0 will have the offset of the array to indicate which score to overwrite
set_hs_content:
	la $t3, hs_content # address of the hs content array
	add $t3, $t3, $a0 # offset of the array 
	la $t4, temp # the temparary var to convert word to char 
	move $t6, $a1 # the number we are converting
	
	# writing each number individually by applying modulus in powers of 10
	li $t8, 1000
	div $t6, $t8
	mfhi $t6
	mflo $t7
	sw $t7, 0($t4)
	lb $t9, 0($t4)
	addi $t9, $t9, 48
	sb $t9, 0($t3) # first digit

	li $t8, 100
	div $t6, $t8
	mfhi $t6
	mflo $t7
	sw $t7, 0($t4)
	lb $t9, 0($t4)
	addi $t9, $t9, 48
	sb $t9, 1($t3) # second digit
	
	li $t8, 10
	div $t6, $t8
	mfhi $t6
	mflo $t7
	sw $t7, 0($t4)
	lb $t9, 0($t4)
	addi $t9, $t9, 48
	sb $t9, 2($t3) # third digit
	
	sw $t7, 0($t4)
	lb $t9, 0($t4)
	addi $t9, $t9, 48
	sb $t9, 3($t3) # fourth digit
	
	jr $ra

# THE FOLLOWING 4 LABELS PERFORMS HIGHSCORE RANKING
# sorting the highscores to see where to rank the player score
# v0 will indicate if a highscore was achieved by indicating the position of the rank
sort_scores:
	bgt $s6, $t2, swap_hs3 # checking if the player score was better than 3rd place 
	move $v0, $zero # since it wasn't no highscore was achieved -> write zero in v0 to indicate this
	jr $ra
	
swap_hs3:
	move $t2, $s6 # putting player score in 3rd place
	bgt $s6, $t1, swap_hs2 # checking if the player score was better than 2nd place
	li $v0, 3 # since it wasn't better than 2nd, they placed 3rd all-time -> v0 = 3
	jr $ra
	
swap_hs2:
	move $t2, $t1 # swapping 3rd with 2nd, since the new 2nd place is the player score
	move $t1, $s6 # ranking the player score in the 2nd position
	bgt $s6, $t0, swap_hs1 # checking if the player score was better than 1st
	li $v0, 2 # since the player score was not better than 1st, they placed 2nd all-time -> v0 = 2
	jr $ra
	
swap_hs1:
	move $t1, $t0 # swapping second with first since the new 1st place is the player score
	move $t0, $s6 # ranking the player score in 1st position
	li $v0, 1 # v0 = 1 since the player came 1st
	jr $ra

# converts 4 separate bytes in the hs_content array to their appropriate 4-byte integer value
# ex. '0', '3', '5', '1' <=> 351
# a0 contains the offset which indicates which of the 3 numbers we are converting from the hs_content array
# v0 will contain the converted 4-byte integer
bytetoint:
	la $t3, hs_content
	add $t3, $t3, $a0 # storing the address of the first byte of the 4 byte sequence
	
	# THE FOLLOWING 4 BLOCKS OF CODE BEHAVE THE SAME WAY
	# THE FIRST BLOCK WILL CONTAIN COMMENTS ON THE LB, SUBI, and ORI purposes
	lb $t4, 0($t3) # storing one byte of information from the hs_content array
	subi $t4, $t4, 48 # subtracting 48 from its ascii value to obtain its base 10 number representation
	ori $t5, $t4, 0 # bit extending it to 4 bytes
	mul $t5, $t5, 1000 # multiplying it by 1000 since its the first digit in a 4-digit number
	add $v0, $zero, $t5 # storing it in v0
	
	lb $t4, 1($t3)
	subi $t4, $t4, 48
	ori $t5, $t4, 0
	mul $t5, $t5, 100 # multiplying it by 100 since its the second digit in a 4-digit number
	add $v0, $v0, $t5 # adding it to v0
	
	lb $t4, 2($t3)
	subi $t4, $t4, 48
	ori $t5, $t4, 0
	mul $t5, $t5, 10 # multiplying it by 10 since its the third digit in a 4-digit number
	add $v0, $v0, $t5 # adding it to v0
	
	# no need to multiply by 1 even though its the fourth digit in a 4-digit number, its redundant
	lb $t4, 3($t3)
	subi $t4, $t4, 48
	ori $t5, $t4, 0
	add $v0, $v0, $t5
	
	jr $ra

# returns the player score for the gameover sections
get_score:
	la $s6, game_info
	lw $s6, 12($s6)
	jr $ra

# used to finish a function call through a branch label
quick_return:
	jr $ra

#----------------------------------------------#
#    THE LABELS BELOW CONTAIN THE PIXEL ART    #
#----------------------------------------------#

# draws the logo "SPACE EVADE"
draw_logo:
	# spelling "SPACE"
	li $t0, BLUE
	
	#first row
	sw $t0, 400($s0)
	sw $t0, 404($s0)
	sw $t0, 408($s0)
	sw $t0, 412($s0)
	sw $t0, 420($s0)
	sw $t0, 424($s0)
	sw $t0, 428($s0)
	sw $t0, 432($s0)
	sw $t0, 440($s0)
	sw $t0, 444($s0)
	sw $t0, 448($s0)
	sw $t0, 452($s0)
	sw $t0, 460($s0)
	sw $t0, 464($s0)
	sw $t0, 468($s0)
	sw $t0, 472($s0)
	sw $t0, 480($s0)
	sw $t0, 484($s0)
	sw $t0, 488($s0)
	sw $t0, 492($s0)
	
	# second row
	sw $t0, 528($s0)
	sw $t0, 548($s0)
	sw $t0, 560($s0)
	sw $t0, 568($s0)
	sw $t0, 580($s0)
	sw $t0, 588($s0)
	sw $t0, 608($s0)
	
	# third row
	sw $t0, 656($s0)
	sw $t0, 660($s0)
	sw $t0, 664($s0)
	sw $t0, 668($s0)
	
	sw $t0, 676($s0)
	sw $t0, 680($s0)
	sw $t0, 684($s0)
	sw $t0, 688($s0)
	
	sw $t0, 696($s0)
	sw $t0, 700($s0)
	sw $t0, 704($s0)
	sw $t0, 708($s0)
	
	sw $t0, 716($s0)
	
	sw $t0, 736($s0)
	sw $t0, 740($s0)
	sw $t0, 744($s0)
	
	# fourth row
	sw $t0, 796($s0)
	sw $t0, 804($s0)
	sw $t0, 824($s0)
	sw $t0, 836($s0)
	sw $t0, 844($s0)
	sw $t0, 864($s0)

	# fifth row 
	sw $t0, 912($s0)
	sw $t0, 916($s0)
	sw $t0, 920($s0)
	sw $t0, 924($s0)
	sw $t0, 932($s0)
	sw $t0, 952($s0)
	sw $t0, 964($s0)
	sw $t0, 972($s0)
	sw $t0, 976($s0)
	sw $t0, 980($s0)
	sw $t0, 984($s0)
	sw $t0, 992($s0)
	sw $t0, 996($s0)
	sw $t0, 1000($s0)
	sw $t0, 1004($s0)

	# spelling "EVADE"
	li $t0, DARK_BLUE
	
	# first row
	sw $t0, 1296($s0)
	sw $t0, 1300($s0)
	sw $t0, 1304($s0)
	sw $t0, 1308($s0)
	sw $t0, 1316($s0)
	sw $t0, 1328($s0)
	sw $t0, 1336($s0)
	sw $t0, 1340($s0)
	sw $t0, 1344($s0)
	sw $t0, 1348($s0)
	sw $t0, 1356($s0)
	sw $t0, 1360($s0)
	sw $t0, 1364($s0)
	sw $t0, 1376($s0)
	sw $t0, 1380($s0)
	sw $t0, 1384($s0)
	sw $t0, 1388($s0)
	
	# second row
	sw $t0, 1424($s0)
	sw $t0, 1444($s0)
	sw $t0, 1456($s0)
	sw $t0, 1464($s0)
	sw $t0, 1476($s0)
	sw $t0, 1484($s0)
	sw $t0, 1496($s0)
	sw $t0, 1504($s0)

	# third row
	sw $t0, 1552($s0)
	sw $t0, 1556($s0)
	sw $t0, 1560($s0)
	sw $t0, 1572($s0)
	sw $t0, 1584($s0)
	sw $t0, 1592($s0)
	sw $t0, 1596($s0)
	sw $t0, 1600($s0)
	sw $t0, 1604($s0)
	sw $t0, 1612($s0)
	sw $t0, 1624($s0)
	sw $t0, 1632($s0)
	sw $t0, 1636($s0)
	sw $t0, 1640($s0)

	# fourth row
	sw $t0, 1680($s0)
	sw $t0, 1700($s0)
	sw $t0, 1704($s0)
	sw $t0, 1708($s0)
	sw $t0, 1712($s0)
	sw $t0, 1720($s0)
	sw $t0, 1732($s0)
	sw $t0, 1740($s0)
	sw $t0, 1752($s0)
	sw $t0, 1760($s0)
	
	# fifth row
	sw $t0, 1808($s0)
	sw $t0, 1812($s0)
	sw $t0, 1816($s0)
	sw $t0, 1820($s0)
	sw $t0, 1832($s0)
	sw $t0, 1836($s0)
	sw $t0, 1848($s0)
	sw $t0, 1860($s0)
	sw $t0, 1868($s0)
	sw $t0, 1872($s0)
	sw $t0, 1876($s0)
	sw $t0, 1880($s0)
	sw $t0, 1888($s0)
	sw $t0, 1892($s0)
	sw $t0, 1896($s0)
	sw $t0, 1900($s0)

	jr $ra

# draws the dashes in the logo
draw_dash_wrapper:
	li $a3, LIGHT_BLUE
	j write_lines

# draws the prompt message on the starting screen
write_prompt:
	# spelling "PRESS A"
	# first row
	sw $a0, 3084($s0)
	sw $a0, 3088($s0)
	sw $a0, 3092($s0)
	sw $a0, 3100($s0)
	sw $a0, 3104($s0)
	sw $a0, 3108($s0)
	sw $a0, 3116($s0)
	sw $a0, 3120($s0)
	sw $a0, 3124($s0)
	sw $a0, 3132($s0)
	sw $a0, 3136($s0)
	sw $a0, 3140($s0)
	sw $a0, 3148($s0)
	sw $a0, 3152($s0)
	sw $a0, 3156($s0)
	sw $a0, 3176($s0)
	sw $a0, 3180($s0)
	sw $a0, 3184($s0)

	# second row
	sw $a0, 3212($s0)
	sw $a0, 3220($s0)
	sw $a0, 3228($s0)
	sw $a0, 3236($s0)
	sw $a0, 3244($s0)
	sw $a0, 3260($s0)
	sw $a0, 3276($s0)
	sw $a0, 3304($s0)
	sw $a0, 3312($s0)
	
	# third row
	sw $a0, 3340($s0)
	sw $a0, 3344($s0)
	sw $a0, 3348($s0)
	sw $a0, 3356($s0)
	sw $a0, 3360($s0)
	sw $a0, 3372($s0)
	sw $a0, 3376($s0)
	sw $a0, 3380($s0)
	sw $a0, 3388($s0)
	sw $a0, 3392($s0)
	sw $a0, 3396($s0)
	sw $a0, 3404($s0)
	sw $a0, 3408($s0)
	sw $a0, 3412($s0)
	sw $a0, 3432($s0)
	sw $a0, 3436($s0)
	sw $a0, 3440($s0)
	
	# fourth row
	sw $a0, 3468($s0)
	sw $a0, 3484($s0)
	sw $a0, 3492($s0)
	sw $a0, 3500($s0)
	sw $a0, 3524($s0)
	sw $a0, 3540($s0)
	sw $a0, 3560($s0)
	sw $a0, 3568($s0)
	
	# fifth row
	sw $a0, 3596($s0)
	sw $a0, 3612($s0)
	sw $a0, 3620($s0)
	sw $a0, 3628($s0)
	sw $a0, 3632($s0)
	sw $a0, 3636($s0)
	sw $a0, 3644($s0)
	sw $a0, 3648($s0)
	sw $a0, 3652($s0)
	sw $a0, 3660($s0)
	sw $a0, 3664($s0)
	sw $a0, 3668($s0)
	sw $a0, 3688($s0)
	sw $a0, 3696($s0)

	jr $ra

# draws a health bar
draw_health_bar:
 	la $a3, game_info
	lw $a3, 4($a3)
	
	bltz $a3, quick_return
	
	la $a0, HEALTH_BAR_START
	add $a0, $a0, $s0
	li $a1, 0
	j draw_health_bar_dark

# draws the dark portion of the health bar
draw_health_bar_dark:
	addi $sp, $sp, -4
 	sw $ra, 0($sp) # push $ra onto stack
	jal pick_health_bar_dark
	lw $ra, 0($sp)
 	addi $sp, $sp, 4 # get $ra back
	sw $t1, 0($a0)
	sw $t1, 128($a0)
	
	addi $a1, $a1, 1
	addi $a0, $a0 4
	
	blt $a1, $a3, draw_health_bar_light 
	jr $ra

# draws the light portion of the health bar
draw_health_bar_light:
	addi $sp, $sp, -4
 	sw $ra, 0($sp) # push $ra onto stack
	jal pick_health_bar_light
	lw $ra, 0($sp)
 	addi $sp, $sp, 4 # get $ra back
	sw $t1, 0($a0)
	sw $t1, 128($a0)
	
	addi $a1, $a1, 1
	addi $a0, $a0 4
	
	bge $a1, $a3, quick_return
	# the following branches check if a dark portion needs to be drawn (every 4 pixels)
	beq $a1, 4, draw_health_bar_dark
	beq $a1, 8, draw_health_bar_dark
	beq $a1, 12, draw_health_bar_dark
	beq $a1, 16, draw_health_bar_dark
	beq $a1, 20, draw_health_bar_dark
	beq $a1, 24, draw_health_bar_dark
	j draw_health_bar_light	

# THE FOLLOWING 6 LABELS DETERMINE WHICH COLOR TO USE FOR THE HEALTH BAR
# if the health is more than 2/3 -> green
# if the health is between 1/3 and 2/3 -> yellow
# else, red

# chooses the dark color portion
pick_health_bar_dark:
	blt $a3, 8, setRedDark
	blt $a3, 17, setYellowDark
	li $t1, HEALTH_BAR_COLOR1
	jr $ra
	
setRedDark:
	li $t1, HEALTH_BAR_COLOR5
	jr $ra
	
setYellowDark:
	li $t1, HEALTH_BAR_COLOR3
	jr $ra

# chooses the light color portion	
pick_health_bar_light:
	blt $a3, 8, setRedLight
	blt $a3, 17, setYellowLight
	li $t1, HEALTH_BAR_COLOR2
	jr $ra
	
setRedLight:
	li $t1, HEALTH_BAR_COLOR6
	jr $ra
	
setYellowLight:
	li $t1, HEALTH_BAR_COLOR4
	jr $ra

# Drawing the smaller health item (yellow one)
draw_health_item1:
	lw $t0, 0($a0) 
	beq $t0, -1, quick_return
	
	lw $t1, 4($a0) # x coord
	lw $t2, 8($a0) # y coord
	
	sll $t3, $t2, 5
	add $t3, $t3, $t1
	sll $t3, $t3, 2
	add $t3, $t3, $s0
	
	li $t4, BLACK
	sw $t4, 0($t3)
	sw $t4, 4($t3)
	sw $t4, 128($t3)
	sw $t4, 132($t3)
	
	subi $t1, $t1, 1
	sw $t1, 4($a0)
	bltz $t1, clear_item
	
	subi $t3, $t3, 4
	li $t5, HEALTH_ITEM1_COLOR1
	li $t4, HEALTH_ITEM1_COLOR2
	sw $t5, 0($t3)
	sw $t4, 4($t3)
	sw $t4, 128($t3)
	sw $t4, 132($t3)
	
	jr $ra
	
# Drawing the larger health item (red one)
draw_health_item2:
	lw $t0, 0($a0) 
	beq $t0, -1, quick_return
	
	lw $t1, 4($a0) # x coord
	lw $t2, 8($a0) # y coord
	
	sll $t3, $t2, 5
	add $t3, $t3, $t1
	sll $t3, $t3, 2
	add $t3, $t3, $s0
	
	li $t4, BLACK
	sw $t4, 4($t3)
	sw $t4, 8($t3)
	sw $t4, 128($t3)
	sw $t4, 132($t3)
	sw $t4, 136($t3)
	sw $t4, 256($t3)
	sw $t4, 260($t3)
	sw $t4, 264($t3)
	
	subi $t1, $t1, 1
	sw $t1, 4($a0)
	bltz $t1, clear_item
	
	bgt $t1, 31, quick_return
	
	subi $t3, $t3, 4
	li $t5, HEALTH_ITEM2_COLOR1
	li $t4, HEALTH_ITEM2_COLOR2
	sw $t4, 4($t3)
	sw $t5, 8($t3)
	sw $t4, 128($t3)
	sw $t4, 132($t3)
	sw $t5, 136($t3)
	sw $t5, 256($t3)
	sw $t5, 260($t3)
	sw $t5, 264($t3)
	
	jr $ra

# Drawing the bonus point item
draw_point_item:
	lw $t0, 0($a0)
	beq $t0, -1, quick_return
	
	lw $t1, 4($a0)
	lw $t2, 8($a0)
	
	sll $t3, $t2, 5
	add $t3, $t3, $t1
	sll $t3, $t3, 2
	add $t3, $t3, $s0
	
	li $t4, BLACK
	sw $t4, 0($t3)
	sw $t4, 4($t3)
	sw $t5, 128($t3)
	sw $t4, 132($t3)
	
	subi $t1, $t1, 1
	sw $t1, 4($a0)
	bltz $t1, clear_item
	
	li $t4, BLUE
	li $t5, DARK_BLUE
	subi $t3, $t3, 4
	sw $t4, 0($t3)
	sw $t5, 4($t3)
	sw $t5, 128($t3)
	sw $t4, 132($t3)
	
	jr $ra

# draws the spaceship given a color
# the color to use is stored in a0 and a1
draw_ss:
	# uses s0 to s2, and t3 to t7
	la $t3, ss_pixel # start of the array which stores the spaceship's coordinates
	lw $t4, 0($t3) # x coordinate of the spaceship
	lw $t5, 4($t3) # y coordinate of the spaceship
	
	mult $t5, $s1
	mflo $t6
	add $t6, $t6, $t4
	mult $t6, $s2
	mflo $t6
	
	add $t6, $t6, $s0
	sw $a0, 0($t6)
	
	mult $s1, $s2
	mflo $t7 # offset to go down one row
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)
	
	add $t6, $t6, $t7
	sw $a1, 0($t6)
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)

	addi $t5, $t5, 1
	mult $t5, $s1
	mflo $t6
	add $t6, $t6, $t4
	addi $t6, $t6, 1
	mult $t6, $s2
	mflo $t6
	
	add $t6, $t6, $s0
	sw $a0, 0($t6)
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)
	
	mult $t5, $s1
	mflo $t6
	add $t6, $t6, $t4
	subi $t6, $t6, 1
	mult $t6, $s2
	mflo $t6
	
	add $t6, $t6, $s0
	sw $a0, 0($t6)
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)
	
	add $t6, $t6, $t7
	sw $a0, 0($t6)
	
	addi $t5, $t5, 1
	mult $t5, $s1
	mflo $t6
	add $t6, $t6, $t4
	addi $t6, $t6, 2
	mult $t6, $s2
	mflo $t6
	
	add $t6, $t6, $s0
	sw $a0, 0($t6)
	
	jr $ra

# draws the smallest asteroid given a color
draw_asteroid_0:
	# checking if the asteroid is out of bounds
	bltz $a1, quick_return
	bge $a1, 32, quick_return
	
	la $t1, ($s6) # outline color
	la $t2, ($s7) # inner color
	
	#drawing first column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $a1
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t1, 0($t3)
	
	mult $s1, $s2
	mflo $t4 # offset to go down one row
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)

	addi $t5, $a1, 1
	bge $t5, 32, quick_return # checking if the next column can be drawn
	
	#drawing second column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $t5
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t1, 0($t3)
	
	mult $s1, $s2
	mflo $t4 # offset to go down one row
	
	add $t3, $t3, $t4
	sw $t2, 0($t3)
	
	jr $ra

# draws the middle asteroid given a color
draw_asteroid_1:
	# checking if the asteroid is out of bounds
	bltz $a1, quick_return
	bge $a1, 32, quick_return
	
	la $t1, ($s6) # outline color
	la $t2, ($s7) # inner color
	
	#drawing first column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $a1
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t1, 0($t3)
	
	mult $s1, $s2
	mflo $t4 # offset to go down one row
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)

	addi $t5, $a1, 1
	bge $t5, 32, quick_return # checking if the next column can be drawn
	
	#drawing second column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $t5
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t1, 0($t3)
	
	add $t3, $t3, $t4
	sw $t2, 0($t3)

	add $t3, $t3, $t4
	sw $t1, 0($t3)
	
	addi $t5, $t5, 1
	bge $t5, 32, quick_return # checking if the next column can be drawn
	
	#drawing third column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $t5
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	add $t3, $t3, $t4
	sw $t2, 0($t3)
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)

	jr $ra

# draws the largest asteroid given a color
draw_asteroid_2:
	# checking if the asteroid is out of bounds
	bltz $a1, quick_return 
	bge $a1, 32, quick_return
	
	la $t1, ($s6) # outline color
	la $t2, ($s7) # inner color
	
	#drawing first column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $a1
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t2, 0($t3)
	
	mult $s1, $s2
	mflo $t4 # offset to go down one row
	
	add $t3, $t3, $t4
	sw $t2, 0($t3)
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)

	addi $t5, $a1, 1
	bge $t5, 32, quick_return # checking if the next column can be drawn
	
	#drawing second column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $t5
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t2, 0($t3)
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)

	add $t3, $t3, $t4
	sw $t1, 0($t3)
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)
	
	addi $t5, $t5, 1
	bge $t5, 32, quick_return # checking if the next column can be drawn
	
	#drawing third column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $t5
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	sw $t1, 0($t3)
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)
	
	add $t3, $t3, $t4
	sw $t1, 0($t3)
	
	add $t3, $t3, $t4
	sw $t2, 0($t3)
	
	addi $t5, $t5, 1
	bge $t5, 32, quick_return # checking if the next column can be drawn
	
	#drawing fourth column
	mult $a2, $s1
	mflo $t3
	add $t3, $t3, $t5
	mult $t3, $s2
	mflo $t3
	
	add $t3, $t3, $s0
	add $t3, $t3, $t4
	sw $t1, 0($t3)
	
	add $t3, $t3, $t4
	sw $t2, 0($t3)
	
	jr $ra

# writes a number on the screen
# a0 indicates the digit
# a1 indicates the offset from base address
# a2 indicates the color to use
write_number:
	beq $a0, 0, write_0
	beq $a0, 1, write_1
	beq $a0, 2, write_2
	beq $a0, 3, write_3
	beq $a0, 4, write_4
	beq $a0, 5, write_5
	beq $a0, 6, write_6
	beq $a0, 7, write_7
	beq $a0, 8, write_8
	j write_9
	
# removes a number by coloring it in black
# a0 indicates the digit
# a1 indicates the offset from base address
remove_number:
	li $a2, BLACK

	beq $a0, 0, write_0
	beq $a0, 1, write_1
	beq $a0, 2, write_2
	beq $a0, 3, write_3
	beq $a0, 4, write_4
	beq $a0, 5, write_5
	beq $a0, 6, write_6
	beq $a0, 7, write_7
	beq $a0, 8, write_8
	j write_9

# THE FOLLOWING LABELS WRITE THE NUMBERS 0,1,2,3,4,5,6,7,8,9 (the parameters from write_number and remove_number are preserved)
write_0:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	sw $a2, 140($a1)
	
	sw $a2, 256($a1)
	sw $a2, 268($a1)
	
	sw $a2, 384($a1)
	sw $a2, 396($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)
	
	jr $ra

write_1:
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	
	sw $a2, 136($a1)
	sw $a2, 264($a1)
	sw $a2, 392($a1)
	
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)

	jr $ra

write_2:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 140($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 384($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)
	
	jr $ra

write_3:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 140($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 396($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)

	jr $ra

write_4:
	sw $a2, 0($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	sw $a2, 140($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 396($a1)
	
	sw $a2, 524($a1)

	jr $ra

write_5:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 396($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)

	jr $ra

write_6:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 384($a1)
	sw $a2, 396($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)

	jr $ra

write_7:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	sw $a2, 140($a1)
	
	sw $a2, 268($a1)
	sw $a2, 396($a1)
	sw $a2, 524($a1)

	jr $ra

write_8:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	sw $a2, 140($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 384($a1)
	sw $a2, 396($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)

	jr $ra

write_9:
	sw $a2, 0($a1)
	sw $a2, 4($a1)
	sw $a2, 8($a1)
	sw $a2, 12($a1)
	
	sw $a2, 128($a1)
	sw $a2, 140($a1)
	
	sw $a2, 256($a1)
	sw $a2, 260($a1)
	sw $a2, 264($a1)
	sw $a2, 268($a1)
	
	sw $a2, 396($a1)
	
	sw $a2, 512($a1)
	sw $a2, 516($a1)
	sw $a2, 520($a1)
	sw $a2, 524($a1)

	jr $ra

# THE FOLLOWING 2 LABELS DRAWS A STRAIGHT LINE IN WHITE
# a0 indicates the offset to start from
# a1 indicates the offset to end at
write_lines_wrapper:
	li $a3, WHITE
	j write_lines
	
write_lines:
	add $t0, $a0, $s0
	sw $a3, 0($t0)
	
	addi $a0, $a0, 4
	bgt $a0, $a1, quick_return
	j write_lines

draw_vertical_line:
	beq $a0, $a1, quick_return
	addi $a0, $a0, 128
	add $t0, $a0, $s0
	sw $a2, 0($t0)
	j draw_vertical_line

# Writes the word "GAMEOVER!"
write_gameover:
	la $t1, RED
	
	# row 1
	sw $t1, 528($s0)
	sw $t1, 532($s0)
	sw $t1, 536($s0)
	sw $t1, 540($s0)
	sw $t1, 544($s0)
	
	sw $t1, 556($s0)
	sw $t1, 560($s0)
	sw $t1, 564($s0)
	
	sw $t1, 576($s0)
	sw $t1, 592($s0)
	
	sw $t1, 600($s0)
	sw $t1, 604($s0)
	sw $t1, 608($s0)
	sw $t1, 612($s0)
	sw $t1, 616($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 2
	sw $t1, 656($s0)
	sw $t1, 680($s0)
	sw $t1, 696($s0)
	sw $t1, 704($s0)
	sw $t1, 708($s0)
	sw $t1, 716($s0)
	sw $t1, 720($s0)
	sw $t1, 728($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 3
	sw $t1, 784($s0)
	sw $t1, 792($s0)
	sw $t1, 796($s0)
	sw $t1, 800($s0)
	
	sw $t1, 808($s0)
	sw $t1, 812($s0)
	sw $t1, 816($s0)
	sw $t1, 820($s0)
	sw $t1, 824($s0)
	
	sw $t1, 832($s0)
	sw $t1, 840($s0)
	sw $t1, 848($s0)
	
	sw $t1, 856($s0)
	sw $t1, 860($s0)
	sw $t1, 864($s0)
	sw $t1, 868($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 4
	sw $t1, 912($s0)
	sw $t1, 928($s0)
	sw $t1, 936($s0)
	sw $t1, 952($s0)
	sw $t1, 960($s0)
	sw $t1, 976($s0)
	sw $t1, 984($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 5
	sw $t1, 1040($s0)
	sw $t1, 1044($s0)
	sw $t1, 1048($s0)
	sw $t1, 1052($s0)
	sw $t1, 1056($s0)
	
	sw $t1, 1064($s0)
	sw $t1, 1080($s0)
	
	sw $t1, 1088($s0)
	sw $t1, 1104($s0)
	
	sw $t1, 1112($s0)
	sw $t1, 1116($s0)
	sw $t1, 1120($s0)
	sw $t1, 1124($s0)
	sw $t1, 1128($s0)
	
	sw $t1, 1268($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 6
	sw $t1, 1288($s0)
	sw $t1, 1292($s0)
	sw $t1, 1296($s0)
	sw $t1, 1300($s0)
	sw $t1, 1304($s0)
	
	sw $t1, 1312($s0)
	sw $t1, 1328($s0)
	
	sw $t1, 1336($s0)
	sw $t1, 1340($s0)
	sw $t1, 1344($s0)
	sw $t1, 1348($s0)
	sw $t1, 1352($s0)
	
	sw $t1, 1360($s0)
	sw $t1, 1364($s0)
	sw $t1, 1368($s0)
	sw $t1, 1372($s0)
	
	sw $t1, 1392($s0)
	sw $t1, 1396($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 7
	sw $t1, 1416($s0)
	sw $t1, 1432($s0)
	
	sw $t1, 1440($s0)
	sw $t1, 1456($s0)
	
	sw $t1, 1464($s0)
	
	sw $t1, 1488($s0)
	sw $t1, 1504($s0)
	
	sw $t1, 1516($s0)
	sw $t1, 1520($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 8
	sw $t1, 1544($s0)
	sw $t1, 1560($s0)
	
	sw $t1, 1568($s0)
	sw $t1, 1584($s0)
	
	sw $t1, 1592($s0)
	sw $t1, 1596($s0)
	sw $t1, 1600($s0)
	sw $t1, 1604($s0)
	
	sw $t1, 1616($s0)
	sw $t1, 1620($s0)
	sw $t1, 1624($s0)
	sw $t1, 1628($s0)
	
	sw $t1, 1644($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 9
	sw $t1, 1672($s0)
	sw $t1, 1688($s0)
	
	sw $t1, 1700($s0)
	sw $t1, 1708($s0)
	
	sw $t1, 1720($s0)
	
	sw $t1, 1744($s0)
	sw $t1, 1760($s0)
	
	li $v0, 32
	li $a0, WRITING_DELAY
	syscall
	
	# row 10
	sw $t1, 1800($s0)
	sw $t1, 1804($s0)
	sw $t1, 1808($s0)
	sw $t1, 1812($s0)
	sw $t1, 1816($s0)
	
	sw $t1, 1832($s0)
	
	sw $t1, 1848($s0)
	sw $t1, 1852($s0)
	sw $t1, 1856($s0)
	sw $t1, 1860($s0)
	sw $t1, 1864($s0)
	
	sw $t1, 1872($s0)
	sw $t1, 1888($s0)
	
	sw $t1, 1896($s0)

	jr $ra

# Writes the words "HS.LIST"
write_hs_list:
	li $t0, WHITE
	
	# writing "HS.LIST"
	# first row
	sw $t0, 272($s0)
	sw $t0, 280($s0)
	sw $t0, 288($s0)
	sw $t0, 292($s0)
	sw $t0, 296($s0)
	sw $t0, 312($s0)
	sw $t0, 328($s0)
	sw $t0, 336($s0)
	sw $t0, 340($s0)
	sw $t0, 344($s0)
	sw $t0, 352($s0)
	sw $t0, 356($s0)
	sw $t0, 360($s0)
	sw $t0, 364($s0)
	
	# second row
	sw $t0, 400($s0)
	sw $t0, 408($s0)
	sw $t0, 416($s0)
	sw $t0, 440($s0)
	sw $t0, 456($s0)
	sw $t0, 464($s0)
	sw $t0, 488($s0)
	
	# third row
	sw $t0, 528($s0)
	sw $t0, 532($s0)
	sw $t0, 536($s0)
	sw $t0, 544($s0)
	sw $t0, 548($s0)
	sw $t0, 552($s0)
	sw $t0, 568($s0)
	sw $t0, 584($s0)
	sw $t0, 592($s0)
	sw $t0, 596($s0)
	sw $t0, 600($s0)
	sw $t0, 616($s0)
	
	# fourth row
	sw $t0, 656($s0)
	sw $t0, 664($s0)
	sw $t0, 680($s0)
	sw $t0, 696($s0)
	sw $t0, 712($s0)
	sw $t0, 728($s0)
	sw $t0, 744($s0)
	
	# fifth row
	sw $t0, 784($s0)
	sw $t0, 792($s0)
	sw $t0, 800($s0)
	sw $t0, 804($s0)
	sw $t0, 808($s0)
	sw $t0, 816($s0)
	sw $t0, 824($s0)
	sw $t0, 828($s0)
	sw $t0, 832($s0)
	sw $t0, 840($s0)
	sw $t0, 848($s0)
	sw $t0, 852($s0)
	sw $t0, 856($s0)
	sw $t0, 872($s0)
	
	jr $ra

# Writes the new highscore
write_new_hs:
	li $t0, YELLOW
	
	# row1
	sw $t0, 408($s0)
	sw $t0, 420($s0)
	sw $t0, 428($s0)
	sw $t0, 436($s0)
	sw $t0, 440($s0)
	sw $t0, 444($s0)
	sw $t0, 448($s0)
	sw $t0, 456($s0)
	sw $t0, 468($s0)
	
	# row2
	sw $t0, 536($s0)
	sw $t0, 548($s0)
	sw $t0, 556($s0)
	sw $t0, 564($s0)
	sw $t0, 584($s0)
	sw $t0, 596($s0)
	
	# row3
	sw $t0, 664($s0)
	sw $t0, 668($s0)
	sw $t0, 672($s0)
	sw $t0, 676($s0)
	sw $t0, 684($s0)
	sw $t0, 692($s0)
	sw $t0, 700($s0)
	sw $t0, 704($s0)
	sw $t0, 712($s0)
	sw $t0, 716($s0)
	sw $t0, 720($s0)
	sw $t0, 724($s0)
	sw $t0, 732($s0)
	sw $t0, 736($s0)
	
	# row4
	sw $t0, 792($s0)
	sw $t0, 804($s0)
	sw $t0, 812($s0)
	sw $t0, 820($s0)
	sw $t0, 832($s0)
	sw $t0, 840($s0)
	sw $t0, 852($s0)
	
	# row5
	sw $t0, 920($s0)
	sw $t0, 932($s0)
	sw $t0, 940($s0)
	sw $t0, 948($s0)
	sw $t0, 952($s0)
	sw $t0, 956($s0)
	sw $t0, 960($s0)
	sw $t0, 968($s0)
	sw $t0, 980($s0)
	sw $t0, 1016($s0)
	
	# row6
	sw $t0, 1140($s0)
	sw $t0, 1144($s0)
	
	# row7
	sw $t0, 1156($s0)
	sw $t0, 1160($s0)
	sw $t0, 1164($s0)
	sw $t0, 1168($s0)
	sw $t0, 1176($s0)
	sw $t0, 1180($s0) 
	sw $t0, 1184($s0) 
	sw $t0, 1188($s0)
	sw $t0, 1196($s0)  
	sw $t0, 1200($s0)  
	sw $t0, 1204($s0)  
	sw $t0, 1208($s0)
	sw $t0, 1216($s0)
	sw $t0, 1220($s0) 
	sw $t0, 1224($s0)
	sw $t0, 1236($s0)
	sw $t0, 1240($s0)   
	sw $t0, 1244($s0)   
	sw $t0, 1248($s0)
	sw $t0, 1264($s0)
	sw $t0, 1268($s0) 
	
	# row8            
	sw $t0, 1284($s0)
	sw $t0, 1304($s0)
	sw $t0, 1324($s0)
	sw $t0, 1336($s0)
	sw $t0, 1344($s0)
	sw $t0, 1356($s0)
	sw $t0, 1364($s0)
	sw $t0, 1388($s0)
	sw $t0, 1392($s0)
	
	# row9
	sw $t0, 1412($s0)
	sw $t0, 1416($s0)
	sw $t0, 1420($s0)
	sw $t0, 1424($s0)
	sw $t0, 1432($s0)
	sw $t0, 1452($s0)
	sw $t0, 1464($s0)
	sw $t0, 1472($s0)
	sw $t0, 1476($s0)
	sw $t0, 1480($s0)
	sw $t0, 1492($s0)
	sw $t0, 1496($s0)
	sw $t0, 1500($s0)
	sw $t0, 1516($s0)
	
	# row10
	sw $t0, 1552($s0)
	sw $t0, 1560($s0)
	sw $t0, 1580($s0)
	sw $t0, 1592($s0)
	sw $t0, 1600($s0)
	sw $t0, 1612($s0)
	sw $t0, 1620($s0)
	
	# row11
	sw $t0, 1668($s0)
	sw $t0, 1672($s0)
	sw $t0, 1676($s0)
	sw $t0, 1680($s0)
	sw $t0, 1688($s0)
	sw $t0, 1692($s0)
	sw $t0, 1696($s0)
	sw $t0, 1700($s0)
	sw $t0, 1708($s0)
	sw $t0, 1712($s0)
	sw $t0, 1716($s0)
	sw $t0, 1720($s0)
	sw $t0, 1728($s0)
	sw $t0, 1740($s0)
	sw $t0, 1748($s0)
	sw $t0, 1752($s0)
	sw $t0, 1756($s0)
	sw $t0, 1760($s0)
	sw $t0, 1768($s0)

	jr $ra

# Program exit
exit:	
	jal wipe_screen_wrapper # clearing the screen before exiting the program

	li $v0, 10
	syscall
