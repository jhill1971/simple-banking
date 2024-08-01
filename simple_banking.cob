       IDENTIFICATION DIVISION.
       PROGRAM-ID. simple_banking.
       AUTHOR. James Hill.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CLIENT-FILE ASSIGN TO "client-data.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  CLIENT-FILE.
       01 CLIENT-RECORD.
           05 CLIENT-ACCTNUM          PIC X(7).
           05 CLIENT-LASTNAME         PIC X(20).
           05 CLIENT-FIRSTNAME        PIC X(20).
           05 CLIENT-BALANCE          PIC X(9).

       WORKING-STORAGE SECTION.
       77 END-OF-SESSION-SWITCH       PIC X    VALUE "N".
       77 END-OF-FILE                 PIC X    VALUE "N".
       01 USER-ACTIVITY               PIC X.
       77 WS-ACCOUNT-NUMBER           PIC X(7).
       77 WS-DEPOSIT-AMOUNT           PIC 9(7)V99.
       77 WS-WITHDRAWAL-AMOUNT        PIC 9(7)V99.
       77 WS-FORMATTED-BALANCE        PIC 9(7)V99.
       77 WS-BALANCE-TEXT             PIC Z(9).
       01 CLIENT-TABLE.
           05 CLIENT-ENTRY OCCURS 100 TIMES INDEXED BY TABLE-INDEX.
               10 CLIENT-ACCTNUM-T    PIC X(7).
               10 CLIENT-LASTNAME-T   PIC X(20).
               10 CLIENT-FIRSTNAME-T  PIC X(20).
               10 CLIENT-BALANCE-T    PIC S9(7)V99.
       77 WS-CLIENT-INDEX             PIC 9(3) VALUE 1.
       77 WS-DISPLAY-BALANCE          PIC $$,$$$,$$9.99.

       PROCEDURE DIVISION.
       000-MAIN-FUNCTION.
           PERFORM 300-INITIALIZE
           PERFORM 100-ACTIVITY-SELECTION
               UNTIL END-OF-SESSION-SWITCH = "Y".
           DISPLAY "END OF SESSION".
           STOP RUN.

       100-ACTIVITY-SELECTION.
           DISPLAY "********** THE SIMPLE BANK **********".
           DISPLAY "ENTER B TO CHECK YOUR BALANCE".
           DISPLAY "ENTER D TO MAKE A DEPOSIT".
           DISPLAY "ENTER W TO MAKE A WITHDRAWAL".
           DISPLAY "ENTER 0 TO END THIS SESSION".
           DISPLAY "YOUR SELECTION: " WITH NO ADVANCING.
           ACCEPT USER-ACTIVITY.
          
           IF USER-ACTIVITY = "0"
              MOVE "Y" TO END-OF-SESSION-SWITCH
           ELSE
              EVALUATE TRUE
                 WHEN USER-ACTIVITY = "B"
                    PERFORM 110-CHECK-BALANCE
                 WHEN USER-ACTIVITY = "D"
                    PERFORM 120-MAKE-DEPOSIT
                 WHEN USER-ACTIVITY = "W"
                    PERFORM 130-MAKE-WITHDRAWAL
                 WHEN OTHER
                    DISPLAY "UNEXPECTED INPUT. TRY AGAIN."
                    DISPLAY " ".

       110-CHECK-BALANCE.
           DISPLAY "ENTER YOUR ACCOUNT NUMBER:" WITH NO ADVANCING.
           ACCEPT WS-ACCOUNT-NUMBER.
           PERFORM 200-SEARCH-ACCOUNT
           IF TABLE-INDEX NOT > 100
              MOVE CLIENT-BALANCE-T(TABLE-INDEX) TO WS-DISPLAY-BALANCE
              DISPLAY FUNCTION TRIM (CLIENT-FIRSTNAME-T(TABLE-INDEX))
               " " FUNCTION TRIM (CLIENT-LASTNAME-T(TABLE-INDEX))
              DISPLAY "BALANCE: " WS-DISPLAY-BALANCE
           ELSE
              DISPLAY "ACCOUNT NOT FOUND".
           DISPLAY " ".

       120-MAKE-DEPOSIT.
           DISPLAY "ENTER YOUR ACCOUNT NUMBER: " WITH NO ADVANCING.
           ACCEPT WS-ACCOUNT-NUMBER.
           PERFORM 200-SEARCH-ACCOUNT
           IF TABLE-INDEX NOT > 100
              DISPLAY "ENTER DEPOSIT AMOUNT: " WITH NO ADVANCING
              ACCEPT WS-DEPOSIT-AMOUNT
              ADD WS-DEPOSIT-AMOUNT TO CLIENT-BALANCE-T(TABLE-INDEX)
              MOVE CLIENT-BALANCE-T(TABLE-INDEX) TO WS-DISPLAY-BALANCE
              DISPLAY "NEW BALANCE: " WS-DISPLAY-BALANCE
              PERFORM 400-UPDATE-FILE
           ELSE 
              DISPLAY "ACCOUNT NOT FOUND".
           DISPLAY " ".

       130-MAKE-WITHDRAWAL.
           DISPLAY "ENTER YOUR ACCOUNT NUMBER: " WITH NO ADVANCING.
           ACCEPT WS-ACCOUNT-NUMBER.
           PERFORM 200-SEARCH-ACCOUNT
           IF TABLE-INDEX NOT > 100
              DISPLAY "ENTER WITHDRAWAL AMOUNT: " WITH NO ADVANCING
              ACCEPT WS-WITHDRAWAL-AMOUNT
              IF WS-WITHDRAWAL-AMOUNT <= CLIENT-BALANCE-T(TABLE-INDEX)
                 SUBTRACT WS-WITHDRAWAL-AMOUNT FROM 
                 CLIENT-BALANCE-T(TABLE-INDEX)
                 MOVE CLIENT-BALANCE-T(TABLE-INDEX) TO
                  WS-DISPLAY-BALANCE
                 DISPLAY "NEW BALANCE: " WS-DISPLAY-BALANCE
                 PERFORM 400-UPDATE-FILE
              ELSE 
                 DISPLAY "INSUFFICIENT FUNDS"
              
           ELSE 
              DISPLAY "ACCOUNT NOT FOUND".
          
           DISPLAY " ".

       200-SEARCH-ACCOUNT.
           SET TABLE-INDEX TO 1
           SEARCH CLIENT-ENTRY
              AT END SET TABLE-INDEX TO 101
              WHEN CLIENT-ACCTNUM-T(TABLE-INDEX) = WS-ACCOUNT-NUMBER
                 CONTINUE
           END-SEARCH.
       
       300-INITIALIZE.
           OPEN INPUT CLIENT-FILE
           PERFORM 310-READ-CLIENT-FILE
              UNTIL END-OF-FILE = "Y"
           CLOSE CLIENT-FILE.
       
       310-READ-CLIENT-FILE.
           READ CLIENT-FILE 
              AT END MOVE "Y" TO END-OF-FILE
              NOT AT END 
                 MOVE CLIENT-ACCTNUM TO CLIENT-ACCTNUM-T(TABLE-INDEX)
                 MOVE CLIENT-LASTNAME TO CLIENT-LASTNAME-T(TABLE-INDEX)
                 MOVE CLIENT-FIRSTNAME TO
                  CLIENT-FIRSTNAME-T(TABLE-INDEX)
                 MOVE FUNCTION NUMVAL (CLIENT-BALANCE) TO
                  CLIENT-BALANCE-T(TABLE-INDEX)
                 ADD 1 TO TABLE-INDEX
           END-READ.

       400-UPDATE-FILE.
           OPEN OUTPUT CLIENT-FILE
           PERFORM 410-REWRITE-CLIENT-FILE
           CLOSE CLIENT-FILE.

       410-REWRITE-CLIENT-FILE.
           PERFORM VARYING TABLE-INDEX FROM 1 BY 1 UNTIL
            TABLE-INDEX > 100 OR CLIENT-ACCTNUM-T(TABLE-INDEX) = SPACES
               MOVE CLIENT-ACCTNUM-T(TABLE-INDEX) TO CLIENT-ACCTNUM
               MOVE CLIENT-LASTNAME-T(TABLE-INDEX) TO CLIENT-LASTNAME
               MOVE CLIENT-FIRSTNAME-T(TABLE-INDEX) TO CLIENT-FIRSTNAME
               MOVE CLIENT-BALANCE-T(TABLE-INDEX) TO
                WS-FORMATTED-BALANCE
               MOVE FUNCTION NUMVAL-C(WS-FORMATTED-BALANCE) TO
                WS-BALANCE-TEXT
               STRING 
                   CLIENT-ACCTNUM DELIMITED BY SIZE
                   " " DELIMITED BY SIZE
                   CLIENT-LASTNAME DELIMITED BY SIZE
                   " " DELIMITED BY SIZE
                   CLIENT-FIRSTNAME DELIMITED BY SIZE
                   " " DELIMITED BY SIZE
                   WS-BALANCE-TEXT DELIMITED BY SIZE
                   INTO CLIENT-RECORD
               END-STRING
               WRITE CLIENT-RECORD
           END-PERFORM.
