# Go-task 

This MATLAB script presents an experimental task where participants are shown a series of visual stimuli in the form of colored circles. Participants are required to respond to specific stimuli (green circle) by pressing the spacebar. The script has potential integration points with transcranial magnetic stimulation (TMS) devices by triggering a parallel port (by io64 drivers). 

## Description

This repository contains a MATLAB script designed for an experimental task where participants view a sequence of colored circles. Participants are required to respond to specific stimuli (green circle) by pressing the spacebar. The script has potential integration points with transcranial magnetic stimulation (TMS) devices. 

## Prerequisites

Before running the script, ensure you have the following:

- MATLAB installed on your system.
- [Psychtoolbox](http://psychtoolbox.org/) installed in MATLAB. This toolbox is essential for the visual stimulus presentation and response collection functionalities of the script.

## Features

- **Stimulus Presentation**: Presents circles in various colors: grey, yellow, and green (plus a white one at the end for transition). It is possible to choose a 'fixed' condition (circles duration does not change during the trials) or a 'random' condition (grey and / or yellow circles change their durations during the trials). 
- **Variable Timing**: The grey circle's appearance duration is random between 1000-3000ms. The yellow circle, which might be associated with a TMS stimulus, also has a variable appearance time. You can easy modify the timing variables inside the function if needed. 
- **TMS Integration**: Contains commented-out sections for sending signals to a TMS device using the `io64` function. This can be activated for experiments that require TMS stimulation.
- **Response Collection**: Monitors for keypresses to log reaction times and categorizes responses based on the timing of the keypress in relation to the visual stimulus.
- **Data Saving**: 
  - Saves trial data to a `.mat` file.
  - `trial_struct` is the main saved structure containing:
    1. Trial number.
    2. Trial type (color name where the key was pressed) or NaN if no keypress was detected.
    3. Reaction time (time taken to press the key) or NaN if no keypress was detected.
    4. Total trial time (duration of the entire trial).
    5. Variable value of the grey circle.
    6. Variable value of the yellow circle.
  - If an existing file has the same name, the script appends a counter to the filename to ensure no data is overwritten.
- **User Input**: Prompts the experimenter at the start to enter a subject number and run number, which are used in naming the saved data file.
- **Features**: Press 'q' to close the experiment; press 'spacebar' during the experiment as a response for the response collection.

## Setup

1. Clone this repository or download the source files.
2. Ensure that the `functions` folder is in the same directory as the main script. This folder contains necessary functions that the script relies upon.
3. If integrating with TMS, uncomment the relevant sections of the code inside the function and ensure the TMS device is properly connected and configured. The TMS code needs the io64 parallel port driver correctly installed. This part of the code can be moved in other steps inside the function if needed. 

## Usage

To run the experiment:

1. Open MATLAB and navigate to the directory containing the script.
2. Run the main script.
3. When prompted, enter the relevant subject and run numbers.
4. Follow the on-screen instructions for the experiment. 

## Contributing

If you find any bugs or would like to improve the script, please open an issue or submit a pull request.

