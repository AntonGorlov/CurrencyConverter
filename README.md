# CurrencyConverter
Description:
Online currency converter. allows users to convert currencies using real-time exchange rates

This project is a Currency Converter App built using UIKit programmatically. It uses a modular architecture for the BackendAPI package and includes unit tests for the API.

Currency Conversion:
- Users can select a source currency and a target currency.
- Users can input an amount to convert.
- Every time the amount is changed or the currency is selected, a request is made
- The app automatically updates the converted amount when the input changes or periodically (every 10 seconds).

Modular Architecture:
The BackendAPI package is modular and can be reused across different projects.
The app follows the MVVM pattern for clean separation of concerns.

Error Handling:
The app handles errors gracefully and displays user-friendly messages.

Unit Tests:
The BackendAPI package includes unit tests to ensure reliability.

Requirements:
Xcode 14+ (Swift 5.7+)
iOS 15+
Swift Package Manager (for BackendAPI package)

Install Dependencies
The BackendAPI package is included as a local Swift package. Ensure it is linked correctly in Xcode:
Go to File > Swift Packages > Add Local Package.
Select the BackendAPI folder.

Run the App:
Select a simulator or a physical device.
Press Cmd + R to build and run the app.

Usage:
Select Currencies:
Use the pickers to select the source and target currencies.

Enter Amount:
Input the amount you want to convert in the text field.

View Result:
The converted amount will be displayed automatically.

Testing
Run Unit Tests
Press Cmd + U to run tests

Modular Architecture
BackendAPI Package
The BackendAPI package is designed to be reusable and modular. It includes:

APIClient: Handles network requests.
Services: Business logic for currency conversion.
Models: Data models for API responses.
Errors: Custom error handling.

License
This project is licensed under the MIT License. See the LICENSE file for details.

