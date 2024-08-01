# Simple Banking System in COBOL

## Overview
This is a simple banking system application written in COBOL. It allows users to perform basic banking operations such as checking their balance, making deposits, and making withdrawals. The application reads from and writes to a space-delimited text file to store client data.

## Features
- **Check Balance**: View the current balance of an account.
- **Make Deposit**: Add a specified amount to an account's balance.
- **Make Withdrawal**: Subtract a specified amount from an account's balance (if funds are sufficient).

## Files
- **simple_banking.cob**: The main COBOL program.
- **client-data.txt**: The data file containing client information.

## Data File Format
The `client-data.txt` file contains client information in the following format:
acctnum lastname firstname balance
0001001 Simpson Homer 00200000
0001002 Flintstone Fred 00155050

Each field is space-delimited.

## Program Structure
- **IDENTIFICATION DIVISION**: Program identification.
- **ENVIRONMENT DIVISION**: File control configurations.
- **DATA DIVISION**: File and working-storage declarations.
- **PROCEDURE DIVISION**: Main logic of the program.

### Main Sections
1. **100-ACTIVITY-SELECTION**: Displays menu and handles user input.
2. **110-CHECK-BALANCE**: Checks and displays account balance.
3. **120-MAKE-DEPOSIT**: Handles deposit transactions.
4. **130-MAKE-WITHDRAWAL**: Handles withdrawal transactions.
5. **200-SEARCH-ACCOUNT**: Searches for an account by account number.
6. **300-INITIALIZE**: Initializes the application by reading the data file.
7. **400-UPDATE-FILE**: Updates the data file with the current state of the client data.
8. **410-REWRITE-CLIENT-FILE**: Rewrites the entire client data file.

## Compilation and Execution
To compile and run the program, follow these steps:

1. **Compile the Program**:
   ```sh
   cobc -x simple_banking.cob -o simple_banking
2. **Run the Program**:
    ./simple_banking

## Sample Usage:
********** THE SIMPLE BANK **********
ENTER B TO CHECK YOUR BALANCE
ENTER D TO MAKE A DEPOSIT
ENTER W TO MAKE A WITHDRAWAL
ENTER 0 TO END THIS SESSION
YOUR SELECTION: B
ENTER YOUR ACCOUNT NUMBER: 0001001
Homer Simpson
BALANCE:       $2,200.00

********** THE SIMPLE BANK **********
ENTER B TO CHECK YOUR BALANCE
ENTER D TO MAKE A DEPOSIT
ENTER W TO MAKE A WITHDRAWAL
ENTER 0 TO END THIS SESSION
YOUR SELECTION: 0
END OF SESSION
