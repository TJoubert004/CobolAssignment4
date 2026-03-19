       IDENTIFICATION DIVISION.

       PROGRAM-ID. RPT3000.
      *****************************************************************
      *  Programmers: Tristan Joubert Clay Rasmussen
      *  Date.......: February 19, 2025
      *  GitHub URL.: https://github.com/TJoubert004/CobolAssignment3
      *  Description: The RPT3000 program is an enhanced COBOL
      *               reporting tool. It serves as a data processing
      *               utility that reads customer financial records
      *               from a master input file (CUSTMAST) and
      *               generates a formatted, multi-columnar
      *               Year-To-Date (YTD) Sales Report. This version 
      *               also displays the branch totals.
      *****************************************************************
       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT CUSTMAST ASSIGN TO CUSTMAST.
           SELECT OUTPUT-RPT3000 ASSIGN TO RPT3000.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTMAST
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 130 CHARACTERS
           BLOCK CONTAINS 130 CHARACTERS.
       01  CUSTOMER-MASTER-RECORD.
           05  CM-BRANCH-NUMBER        PIC 9(2).
           05  CM-SALESREP-NUMBER      PIC 9(2).
           05  CM-CUSTOMER-NUMBER      PIC 9(5).
           05  CM-CUSTOMER-NAME        PIC X(20).
           05  CM-SALES-THIS-YTD       PIC S9(5)V9(2).
           05  CM-SALES-LAST-YTD       PIC S9(5)V9(2).
           05  FILLER                  PIC X(87).

       FD  OUTPUT-RPT3000
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 130 CHARACTERS
           BLOCK CONTAINS 130 CHARACTERS.
       01  PRINT-AREA      PIC X(130).

       WORKING-STORAGE SECTION.
       01  SWITCHES.
           05  CUSTMAST-EOF-SWITCH     PIC X    VALUE "N".

       01  PRINT-FIELDS.
           05  PAGE-COUNT      PIC S9(3)   VALUE ZERO.
           05  LINES-ON-PAGE   PIC S9(3)   VALUE +55.
           05  LINE-COUNT      PIC S9(3)   VALUE +99.
           05  SPACE-CONTROL   PIC S9.

       01  TOTAL-FIELDS.
           05  GRAND-TOTAL-THIS-YTD   PIC S9(7)V99   VALUE ZERO.
           05  GRAND-TOTAL-LAST-YTD   PIC S9(7)V99   VALUE ZERO.
           05  GRAND-TOTAL-CHANGE-AMT PIC S9(7)V99   VALUE ZERO.
           05  GRAND-TOTAL-CHANGE-PCT PIC S9(3)V9    VALUE ZERO.

       01  CALCULATION-FIELDS.
           05  WS-CHANGE-AMOUNT       PIC S9(7)V99   VALUE ZERO.
           05  WS-CHANGE-PERCENT      PIC S9(3)V9    VALUE ZERO.

       01  CURRENT-DATE-AND-TIME.
           05  CD-YEAR         PIC 9999.
           05  CD-MONTH        PIC 99.
           05  CD-DAY          PIC 99.
           05  CD-HOURS        PIC 99.
           05  CD-MINUTES      PIC 99.
           05  FILLER          PIC X(9).

       01  HEADING-LINE-1.
           05  FILLER          PIC X(7)    VALUE "DATE:  ".
           05  HL1-MONTH       PIC 9(2).
           05  FILLER          PIC X(1)    VALUE "/".
           05  HL1-DAY         PIC 9(2).
           05  FILLER          PIC X(1)    VALUE "/".
           05  HL1-YEAR        PIC 9(4).
           05  FILLER          PIC X(16)   VALUE SPACE.
           05  FILLER     PIC X(25)   VALUE "YEAR-TO-DATE SALES REPORT".
           05  FILLER          PIC X(19)   VALUE "           PAGE: ".
           05  HL1-PAGE-NUMBER PIC ZZZ9.
           05  FILLER          PIC X(55)   VALUE SPACE.

       01  HEADING-LINE-2.
           05  FILLER          PIC X(7)    VALUE "TIME:  ".
           05  HL2-HOURS       PIC 9(2).
           05  FILLER          PIC X(1)    VALUE ":".
           05  HL2-MINUTES     PIC 9(2).
           05  FILLER          PIC X(57)   VALUE SPACE.
           05  FILLER          PIC X(10)   VALUE "RPT3000".
           05  FILLER          PIC X(45)   VALUE SPACE.

       01  HEADING-LINE-3.
           05  FILLER PIC X(20) VALUE "BRANCH SALES CUST   ".
           05  FILLER PIC X(23) VALUE "SALES                  ".
           05  FILLER PIC X(14) VALUE "SALES    ".
           05  FILLER PIC X(14) VALUE "CHANGE        ".
           05  FILLER PIC X(7)  VALUE "CHANGE ".
           05  FILLER PIC X(52) VALUE SPACE.

       01  HEADING-LINE-4.
           05  FILLER PIC X(20) VALUE "NUM    REP   NUM".
           05  FILLER PIC X(23) VALUE "CUSTOMER NAME          ".
           05  FILLER PIC X(14) VALUE "THIS YTD      ".
           05  FILLER PIC X(14) VALUE "LAST YTD      ".
           05  FILLER PIC X(13) VALUE "AMOUNT       ".
           05  FILLER PIC X(7)  VALUE "PERCENT".
           05  FILLER PIC X(39) VALUE SPACE.

       01  HEADING-LINE-5.
           05  FILLER PIC X(6)  VALUE ALL "-".
           05  FILLER PIC X(1)  VALUE SPACE.
           05  FILLER PIC X(5)  VALUE ALL "-".
           05  FILLER PIC X(1)  VALUE SPACE.
           05  FILLER PIC X(5)  VALUE ALL "-".
           05  FILLER PIC X(2)  VALUE SPACE.
           05  FILLER PIC X(20) VALUE ALL "-".
           05  FILLER PIC X(3)  VALUE SPACE.
           05  FILLER PIC X(10) VALUE ALL "-".
           05  FILLER PIC X(4)  VALUE SPACE.
           05  FILLER PIC X(10) VALUE ALL "-".
           05  FILLER PIC X(4)  VALUE SPACE.
           05  FILLER PIC X(10) VALUE ALL "-".
           05  FILLER PIC X(3)  VALUE SPACE.
           05  FILLER PIC X(7)  VALUE ALL "-".
           05  FILLER PIC X(39) VALUE SPACE.

       01  CUSTOMER-LINE.
           05  CL-BRANCH-NUMBER    PIC 9(2).
           05  FILLER              PIC X(5)    VALUE SPACE.
           05  CL-SALESREP-NUMBER  PIC 9(2).
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  CL-CUSTOMER-NUMBER  PIC 9(5).
           05  FILLER              PIC X(2)    VALUE SPACE.
           05  CL-CUSTOMER-NAME    PIC X(20).
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  CL-SALES-THIS-YTD   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  CL-SALES-LAST-YTD   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  CL-CHANGE-AMOUNT    PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  CL-CHANGE-PERCENT   PIC ZZ9.9-.
           05  FILLER              PIC X(37)   VALUE SPACE.

       01  GRAND-TOTAL-LINE-1.
           05  FILLER              PIC X(43)   VALUE SPACE.
           05  FILLER              PIC X(10)   VALUE ALL "=".
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  FILLER              PIC X(10)   VALUE ALL "=".
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  FILLER              PIC X(10)   VALUE ALL "=".
           05  FILLER              PIC X(3)    VALUE SPACE.
           05  FILLER              PIC X(7)    VALUE ALL "=".
           05  FILLER              PIC X(39)   VALUE SPACE.

       01  GRAND-TOTAL-LINE-2.
           05  FILLER              PIC X(41)   VALUE SPACE.
           05  GTL-SALES-THIS-YTD  PIC Z,ZZZ,ZZ9.99-.
           05  FILLER              PIC X(1)    VALUE SPACE.
           05  GTL-SALES-LAST-YTD  PIC Z,ZZZ,ZZ9.99-.
           05  FILLER              PIC X(1)    VALUE SPACE.
           05  GTL-CHANGE-AMOUNT   PIC Z,ZZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACE.
           05  GTL-CHANGE-PERCENT  PIC ZZ9.9-.
           05  FILLER              PIC X(37)   VALUE SPACE.

       PROCEDURE DIVISION.
       000-PREPARE-SALES-REPORT.
           OPEN INPUT  CUSTMAST
                OUTPUT OUTPUT-RPT3000.
           PERFORM 100-FORMAT-REPORT-HEADING.
           PERFORM 200-PREPARE-SALES-LINES
               UNTIL CUSTMAST-EOF-SWITCH = "Y".
           PERFORM 300-PRINT-GRAND-TOTALS.
           CLOSE CUSTMAST
                 OUTPUT-RPT3000.
           STOP RUN.

       100-FORMAT-REPORT-HEADING.
           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME.
           MOVE CD-MONTH   TO HL1-MONTH.
           MOVE CD-DAY     TO HL1-DAY.
           MOVE CD-YEAR    TO HL1-YEAR.
           MOVE CD-HOURS   TO HL2-HOURS.
           MOVE CD-MINUTES TO HL2-MINUTES.

       200-PREPARE-SALES-LINES.
           PERFORM 210-READ-CUSTOMER-RECORD.
           IF CUSTMAST-EOF-SWITCH = "N"
               PERFORM 220-PRINT-CUSTOMER-LINE.

       210-READ-CUSTOMER-RECORD.
           READ CUSTMAST
               AT END
                   MOVE "Y" TO CUSTMAST-EOF-SWITCH.

       220-PRINT-CUSTOMER-LINE.
           IF LINE-COUNT >= LINES-ON-PAGE
               PERFORM 230-PRINT-HEADING-LINES.

           MOVE CM-BRANCH-NUMBER   TO CL-BRANCH-NUMBER.
           MOVE CM-SALESREP-NUMBER TO CL-SALESREP-NUMBER.
           MOVE CM-CUSTOMER-NUMBER TO CL-CUSTOMER-NUMBER.
           MOVE CM-CUSTOMER-NAME   TO CL-CUSTOMER-NAME.
           MOVE CM-SALES-THIS-YTD  TO CL-SALES-THIS-YTD.
           MOVE CM-SALES-LAST-YTD  TO CL-SALES-LAST-YTD.

           SUBTRACT CM-SALES-LAST-YTD FROM CM-SALES-THIS-YTD
               GIVING WS-CHANGE-AMOUNT.
           MOVE WS-CHANGE-AMOUNT TO CL-CHANGE-AMOUNT.

           IF CM-SALES-LAST-YTD = ZERO
               MOVE 999.9 TO WS-CHANGE-PERCENT
           ELSE
               COMPUTE WS-CHANGE-PERCENT =
                   (WS-CHANGE-AMOUNT / CM-SALES-LAST-YTD) * 100
           END-IF.
           MOVE WS-CHANGE-PERCENT TO CL-CHANGE-PERCENT.

           MOVE CUSTOMER-LINE TO PRINT-AREA.
           WRITE PRINT-AREA.
           ADD 1 TO LINE-COUNT.

           ADD CM-SALES-THIS-YTD TO GRAND-TOTAL-THIS-YTD.
           ADD CM-SALES-LAST-YTD TO GRAND-TOTAL-LAST-YTD.
           ADD WS-CHANGE-AMOUNT  TO GRAND-TOTAL-CHANGE-AMT.

           MOVE 1 TO SPACE-CONTROL.

       230-PRINT-HEADING-LINES.
           ADD 1 TO PAGE-COUNT.
           MOVE PAGE-COUNT     TO HL1-PAGE-NUMBER.
           MOVE HEADING-LINE-1 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-2 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-3 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-4 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-5 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE ZERO TO LINE-COUNT.

       300-PRINT-GRAND-TOTALS.
           MOVE GRAND-TOTAL-LINE-1 TO PRINT-AREA.
           WRITE PRINT-AREA.

           IF GRAND-TOTAL-LAST-YTD = ZERO
               MOVE 999.9 TO GRAND-TOTAL-CHANGE-PCT
           ELSE
               COMPUTE GRAND-TOTAL-CHANGE-PCT =
                   (GRAND-TOTAL-CHANGE-AMT / GRAND-TOTAL-LAST-YTD) * 100
           END-IF.

           MOVE GRAND-TOTAL-THIS-YTD TO GTL-SALES-THIS-YTD.
           MOVE GRAND-TOTAL-LAST-YTD TO GTL-SALES-LAST-YTD.
           MOVE GRAND-TOTAL-CHANGE-AMT TO GTL-CHANGE-AMOUNT.
           MOVE GRAND-TOTAL-CHANGE-PCT TO GTL-CHANGE-PERCENT.

           MOVE GRAND-TOTAL-LINE-2 TO PRINT-AREA.
           WRITE PRINT-AREA.
