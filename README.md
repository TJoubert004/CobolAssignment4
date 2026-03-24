# RPT3000 — Year-To-Date Sales & Branch Reporting Utility

The RPT3000 program is an enhanced COBOL reporting tool designed for data processing and financial analysis. It reads customer financial records from a master input file (**CUSTMAST**) and generates a professionally formatted, multi-columnar **Year-To-Date (YTD) Sales Report**, featuring automated branch-level subtotals and grand totals.

## What it does

The program processes sequential data records to provide deep insights into sales performance across different business sectors:

1.  **File Processing**: Reads 130-character records containing branch numbers, sales rep IDs, and YTD financial data.
2.  **Control Break Logic**: Detects changes in the `BRANCH-NUMBER` to automatically trigger **Branch Totals**, including a calculated change amount and percentage.
3.  **Financial Calculations**: 
    * **Change Amount**: Computes the difference between `THIS-YTD` and `LAST-YTD` sales.
    * **Change Percentage**: Calculates the growth or decline percentage, with a safety check for zero-value denominators (handling new customers).
4.  **Pagination & Formatting**: Automatically handles page headings, time/date stamping via `FUNCTION CURRENT-DATE`, and line counting for clean report breaks.
5.  **Grand Totals**: Concludes the report with a final summary of all company-wide sales data.

## COBOL Concepts Used

In this assignment, I implemented the following enterprise computing concepts:

* **File Handling (FD/SELECT)**: Managed fixed-length (F) recording modes and block-contained structures for input/output operations.
* **Control Break Processing**: Implemented logic to monitor `OLD-BRANCH-NUMBER` against current records to manage hierarchical data reporting.
* **Complex Numeric Editing**: Utilized advanced `PIC` strings like `ZZ,ZZ9.99-` and `Z,ZZZ,ZZ9.99-` to handle both positive and negative financial fluctuations.
* **Procedural Paragraphs**: Organized the `PROCEDURE DIVISION` into modular blocks (100, 300, 500 series) for better readability and maintenance.
* **Conditional Logic**: Used `IF/ELSE` structures and `ON SIZE ERROR` phrases to ensure mathematical stability during percentage divisions.

## Program Output

Below is a screenshot of the generated report showing the formatted customer lines, branch subtotals, and the final grand totals:

![Program Output](assests/RPT3000_Output.png) 

---

### Author Profiles
* [Tristan Joubert - GitHub](https://github.com/TJoubert004)
