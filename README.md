# Muscle Fiber Analyzer

### Summary

A semi-automatic Application for the analysis and classification of muscle fiber images.

### Description

The software performs muscle fiber segmentation, extracts geometric, morphological, and intensity-based properties, and classifies fibers using multiple classification approaches. All extracted data can be stored for further analysis and documentation. The application was designed to be usable without prior MATLAB knowledge and therefore provides an intuitive and easy-to-understand graphical user interface.

Rather than aiming for a fully automatic algorithm, the goal of Muscle_Fiber_Analyzer is to provide a practical and flexible analysis tool that facilitates the daily work of veterinarians, biologists, and laboratory technicians. The software is provided free of charge for research and educational purposes to erveryone.

• Analyze Methods:

    - OPTICS clustering for density-based, unsupervised classification
    - Pseudo-color–based classification derived from fluorescence signal characteristics
    - Manual classification with direct user assignment

![Muscle Fiber Analyzer](./Functions/StartScreen/StartScreen5.png)

1. In order to use the App download the folowing folders:
  - Functions
  - MVC
  - NotifySounds

2. Download the "main.m" file 

3. main.m and all Folders from step 2 has to be stored in the same directory.

4. Run main.m


# WHATS NEW:

Version 1.5 

    - App-design can now be changed in the menu bar.
    - Users can save and load their own settings.
    - Histograms now show a Gaussian fit.
    - Boundaries will be plotting faster.
    - Binary Mask can now be saved as an image after processing the fibers.
    - Added About selection to the menu bar for more information.
    - Added Watershed II Automatic Binarisation.
    - App will now inform the user when a new version is available.

Version 1.4 (24-November-2023)

    - Fixed an error with incorrect plane identification when using a new file format.

Version 1.3 (3-November-2020)

    - Updated Bio-Format toolbox.
    - Fixed errors that occasionally occur in diameter calculations.
