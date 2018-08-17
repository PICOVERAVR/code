#include <iostream>
using namespace std;

int main() {
    
    // storing the user entered date here
    int month;
    int day;
    int year;
    
    char slash; // a single character to absorb the slash characters from the user input
    
    cout << "Please enter a date in the form (month/day/2-digit-year)" << endl;
    cout << "> ";
    
    cin >> month >> slash >> day >> slash >> year; // actually get date
    
    if (month * day == year) {
        cout << "This year is magic!" << endl;
    } else {
        cout << "This year is not magic." << endl;
    }
    
}

/*
 
 Please enter a date in the form (month/day/2-digit-year)
 > 6/5/30
 This year is magic!
 
 */
