# Trip Calculator

## Prerequisites
- Ensure you have the Flutter SDK and Dart installed.
- If there are platform-related issues, try running:
```bash
flutter doctor
```

## Installation and Running in Chrome
```bash
flutter pub get
flutter run -d chrome
```


## iTrellis Assignment

The project goals are simple: We require a program that calculates the expenses for a group of students who like to go on road trips.

The group agrees in advance to share expenses equally... Your job is to compute, from a list of students and their personal expenses from the trip, the minimum amount of money that must change hands in order to equalize (within one cent) all the students' costs.

The output should include each student's name, and how much each student needs to pay out to any others.
## Project Purpose and Solution Approach

The purpose of this project is to simplify the process of sharing trip-related expenses among a group of students. The program ensures fair distribution of costs by calculating the minimum financial transactions required to equalize everyone’s expenses.

### Solution Approach

1. **Input Data**: The solution takes a list of students, where each student has a name and their total expenses during the trip.
2. **Calculation of Mean Expense**:
   - First, the program calculates the total expenses for the group and divides it by the number of students to find the mean expense per student.
3. **Comparing Individual Expenses**:
   - Each student’s expense is compared with the mean expense, categorizing them into:
     - Students who owe money (expenses below the mean).
     - Students who need to be reimbursed (expenses above the mean).
4. **Transaction Optimization**:
   - Using an iterative approach, the program computes the minimum transactions required to balance these differences. A "payer" pays an appropriate amount to a "receiver" until the debts and credits are fully settled, ensuring no surplus remains.

By implementing this approach, the program ensures fairness and minimizes the number of monetary exchanges between students, simplifying the entire process for the group.
