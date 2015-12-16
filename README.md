# MIPS MVP Sorter for Duke Computer Architecture (CS250) Fall 2015 (Originally created September 2015)

MIPS program that reads in user input (a series of player statistics) and using MIPS floating point instructions, prints players based on sorted value calculation and then prints Most Valuable Player (MVP) on last line.

Value of player: (points-per-game + rebounds-per-game) / turnovers-per-game

Original Instructions:

The goal of this program is get experience reading various input types, structuring a
larger program, and using MIPS floating point instructions. You will need to do a little
research to understand MIPS floating point instructions. Read the SPIM document,
http://spimsimulator.sourceforge.net/HP_AppA.pdf. Page A-73 lists floating-point
instructions but you should read more.

Write a MIPS program called netid_mvp.s , which reads input typed by the user. The
program will read in lines of input as strings.

That is, each line will be read in as its own input using spim’s syscall support for
reading in inputs of different types (formats). The input is a series of player stats.
Each player reports 4 stats distributed across 4 input lines. The first input line is the
player’s last name (string), the second input line is his points per game (float), the
third input is his rebounds per game (float) and the fourth input line is his turnovers
per game (float). The very last line of input should be “DONE”.

Example input is:
James
27.8
8.1
3.5
Curry
29.5
4.6
6.7
Durant
30.1
8.0
4.5
DONE

Important: There is no constraint on the number of players. Your program cannot
simply allocate memory space for a hard-coded number of records (e.g., 10 players).
Instead, your program must accommodate an arbitrary number of players by
allocating space for each player’s data on the heap. Code that does not accommodate
an arbitrary number of players will be penalized.

Furthermore, the program may not read the entire input to determine the number of
players and then perform a single dynamic allocation of heap space. Instead, your
program must dynamically allocate memory as it reads the file. To perform dynamic
memory allocation in MIPS assembly, please see this resource:
http://chortle.ccsu.edu/assemblytutorial/Chapter-33/ass33_4.html

Outputs: First, your program should output a number of lines equal to the number of
players, and each line is the player’s name and his value. The value of a player is
define as:

(points-per-game + rebounds-per-game) / turnovers-per-game

The lines should be sorted in descending order of player values.

Finally, your program should output the name of MVP (Most Valuable Player) as
the last line. MVP is the player whose value is greater than all other players.

For the input example, the output is:
James 10.26
Durant 8.47
Curry 5.09
James

Note 0: The input will specify DONE in caps as illustrated. You may assume an upper
bound on a player’s name length (e.g., 60 characters). The output statistics (e.g.,
player value) need not be rounded.

Note 1: You need not free memory in MIPS. 
