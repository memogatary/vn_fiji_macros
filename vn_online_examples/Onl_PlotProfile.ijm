// This example macro demonstrates how to use the getProfile() function

  // Set alt key down for vertical profile of a rectangular selection
  //setKeyDown("alt");
 
  // Get profile and display values in "Results" window
  run("Clear Results");
  profile = getProfile();
  for (i=0; i<profile.length; i++)
      setResult("Value", i, profile[i]);
  updateResults;

  // Plot profile
  Plot.create("Profile", "X", "Value", profile);

  // Save as spreadsheet compatible text file
  path = getDirectory("home")+"profile.csv";
  saveAs("Results", path);