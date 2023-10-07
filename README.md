# go-task
This MATLAB script presents an experimental task where participants are shown a series of visual stimuli in the form of colored circles. Participants are required to respond to specific stimuli by pressing a key. The script has potential integration points with transcranial magnetic stimulation (TMS) devices by triggering of a parallel port.

# Go-task with possible TMS Integration

## Description

This repository contains a MATLAB script designed for an experimental task where participants view a sequence of colored circles. Participants are required to respond to specific stimuli by pressing a key. The script has potential integration points with transcranial magnetic stimulation (TMS) devices.

## Features

- **Stimulus Presentation**: Presents circles in various colors: grey, yellow, green, and white.
- **Variable Timing**: The grey circle's appearance duration is random between 1001-3001ms. The yellow circle, which might be associated with a TMS stimulus, also has a variable appearance time.
- **TMS Integration**: Contains commented-out sections for sending signals to a TMS device using the `io64` function. This can be activated for experiments that require TMS stimulation.
- **Response Collection**: Monitors for keypresses to log reaction times and categorizes responses based on the timing of the keypress in relation to the visual stimulus.
- **Data Saving**: Saves trial data, including reaction times and other relevant parameters, to a `.mat` file. If an existing file has the same name, the script appends a counter to the filename to ensure no data is overwritten.
- **User Input**: Prompts the experimenter at the start to enter a subject number and run number, which are used in naming the saved data file.

## Setup

1. Clone this repository or download the source files.
2. Ensure that the `functions` folder is in the same directory as the main script. This folder contains necessary functions that the script relies upon.
3. If integrating with TMS, uncomment the relevant sections of the code and ensure the TMS device is properly connected and configured.

## Usage

To run the experiment:

1. Open MATLAB and navigate to the directory containing the script.
2. Run the main script.
3. When prompted, enter the relevant subject and run numbers.
4. Follow the on-screen instructions for the experiment.

## Contributing

If you find any bugs or would like to improve the script, please open an issue or submit a pull request.

## License

This project is open source and available under the [MIT License](LICENSE).

