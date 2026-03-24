# RPT3000 — Advanced Year-To-Date Sales & Branch Reporting

The RPT3000 program is an evolution of the RPT2000 utility, upgraded to handle hierarchical data processing. While the previous version provided a flat list of sales, RPT3000 serves as a sophisticated reporting tool that reads customer financial records and generates a multi-level **Year-To-Date (YTD) Sales Report** with automated branch-level subtotals.

## What it does 

This program introduces **Control Break Logic** to transform raw data into a structured business report:

1.  **Group Suppression**: Unlike the previous version, RPT3000 only prints the Branch Number when it changes, creating a much cleaner, professional visual layout.
2.  **Branch-Level Subtotaling**: Detects whenever a new branch begins, triggers a "Control Break," and calculates/prints sub-totals for that specific branch before moving to the next.
3.  **Two-Tier Accumulation**: Simultaneously tracks `BRANCH-TOTAL` (cleared after every break) and `GRAND-TOTAL` (running sum for the entire company).
4.  **Financial Growth Analysis**: Calculates both the absolute **Change Amount** and the **Change Percentage** between current and last year's performance, including error-handling for division by zero.
5.  **Automated Pagination**: Manages report headers, page numbering, and system timestamps (`FUNCTION CURRENT-DATE`) across multi-page outputs.

## New COBOL Concepts Implemented

In this project, I moved beyond basic file reading to master the following:

* **Control Break Logic**: Implemented the `OLD-BRANCH-NUMBER` buffer to monitor state changes in the input stream.
* **Nested PERFORM Structures**: Developed a modular `PROCEDURE DIVISION` that separates the "Read-Process-Write" cycle from the "Control Break" sub-routines.
* **Hierarchical Accumulators**: Managed multiple levels of numeric storage to ensure branch totals and grand totals remain mathematically distinct.
* **Group Indication**: Used logical switches (`FIRST-RECORD-SWITCH`) to handle "First Record" exceptions and prevent sub-totals from firing on the very first line of the report.
* **Advanced Formatting**: Used `PIC` editing for negative values (e.g., `ZZ,ZZ9.99-`) and forced rounding on percentage calculations.

## Program Output

Below is a screenshot of the RPT3000 execution, showing the clear separation between branches and the final grand totals:

![Program Output](assests/RPT3000_Output.png) 

---

### Author Profiles
* [Tristan Joubert - GitHub](https://github.com/TJoubert004)
