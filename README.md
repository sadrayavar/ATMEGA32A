# Parking Management System

This project is a Parking Management System implemented on an ATmega32A microcontroller. The system features capacity monitoring, time and date management, and a simple user interface through an LCD screen.

## Software Requirements

- Code Vision
- Proteus

## Usage

To use the system, flash the provided code onto the ATmega32A microcontroller and ensure the hardware setup is in place as per the requirements in the Proteus project.

The system includes the following functionalities:

1. **Set time**: The user can set the current time and date.
2. **Input and output Search**: Allows the user to search for the number of entries and exits on a specific day.
3. **Reserve Park**: Enables the user to reserve a parking space.
4. **Set Date**: The user can set the current date.

## Interrupts and Logic

The system makes use of interrupts to handle car entries and exits as well as timer interrupts for time and date logic.

## Files Included

- **main.c**: Contains the main implementation of the Parking Management System.
- **alcd.c, alcd.h**: Custom library for interfacing with the LCD module.
- **delay.h**: Library for delay functions.

## How to Contribute

If you find any issues or have suggestions for improvements, feel free to submit a pull request or open an issue.

## Credits

This project was originally developed by an unknown contributor and was found with several bugs and errors in the implementation. The original source can be found [here](https://melec.ir/parking-automation-circuit-infrared-sensor). I have fixed the issues and re-implemented the code for improved functionality, and it is now available on GitHub for easy access.
