projectRoot = "/Users/sebastianfriedrich/Documents/Developer/Matlab/Muscle_Fiber_Analyzer";

% Create target build options object, set build properties and build.
buildOpts = compiler.build.StandaloneApplicationOptions(fullfile(projectRoot, "main.m"));
buildOpts.AdditionalFiles = [fullfile(projectRoot, "Functions"), fullfile(projectRoot, "Functions", "AppSettings", "AppSettings.mat"), fullfile(projectRoot, "Icons"), fullfile(projectRoot, "LATEST.txt"), fullfile(projectRoot, "MVC")];
buildOpts.AutoDetectDataFiles = true;
buildOpts.OutputDir = fullfile(projectRoot, "Muscle_Fiber_Analyzer_Desktop_App", "output", "build");
buildOpts.ObfuscateArchive = false;
buildOpts.Verbose = true;
buildOpts.EmbedArchive = true;
buildOpts.ExecutableIcon = fullfile(projectRoot, "Icons", "Icon3.png");
buildOpts.ExecutableName = "MuscleFiberAnalyzer_v1_6";
buildOpts.ExecutableVersion = "1.6.0";
buildOpts.TreatInputsAsNumeric = false;
buildResult = compiler.build.standaloneApplication(buildOpts);


% Create package options object, set package properties and package.
packageOpts = compiler.package.InstallerOptions(buildResult);
packageOpts.ApplicationName = "Muscle_Fiber_Analyzer";
packageOpts.AuthorName = "Sebastian Friedrich";
packageOpts.AuthorEmail = "sebastien.friedrich.software@gmail.com";
packageOpts.Description = "The software performs muscle fiber segmentation, extracts geometric, morphological, and intensity-based properties, and classifies fibers using multiple classification approaches. All extracted data can be stored for further analysis and documentation. The application was designed to be usable without prior MATLAB knowledge and therefore provides an intuitive and easy-to-understand graphical user interface." + newline + "" + newline + "Rather than aiming for a fully automatic algorithm, the goal of Muscle_Fiber_Analyzer is to provide a practical and flexible analysis tool that facilitates the daily work of veterinarians, biologists, and laboratory technicians. The software is provided free of charge for research and educational purposes to erveryone." + newline + "" + newline + "• Analyze Methods:" + newline + "    - OPTICS clustering for density-based, unsupervised classification" + newline + "    - Pseudo-color–based classification derived from fluorescence signal characteristics" + newline + "    - Manual classification with direct user assignment" + newline + "" + newline + "";
packageOpts.InstallerIcon = fullfile(projectRoot, "Icons", "Icon3.png");
packageOpts.InstallerLogo = fullfile(projectRoot, "Icons", "Icon_Big_Hoch.png");
packageOpts.InstallerName = "Muscle_Fiber_Analyzer_1-6_Installer";
packageOpts.InstallerSplash = fullfile(projectRoot, "Icons", "Icon5.png");
packageOpts.InstallationNotes = "The software performs muscle fiber segmentation, extracts geometric, morphological, and intensity-based properties, and classifies fibers using multiple classification approaches. All extracted data can be stored for further analysis and documentation. The application was designed to be usable without prior MATLAB knowledge and therefore provides an intuitive and easy-to-understand graphical user interface.";
packageOpts.OutputDir = fullfile(projectRoot, "Muscle_Fiber_Analyzer_Desktop_App", "output", "package");
packageOpts.Summary = "A semi-automatic Application for the analysis and classification of muscle fiber images.";
packageOpts.Verbose = true;
packageOpts.Version = "1.6.0";
compiler.package.installer(buildResult, "Options", packageOpts);