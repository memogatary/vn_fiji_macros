importClass(Packages.ij.WindowManager);
importClass(Packages.ij.measure.ResultsTable); // Ensure this is correctly imported
importClass(Packages.ij.gui.GenericDialog);
importClass(Packages.ij.gui.Plot);
importPackage(Packages.ij.text);

// Function to get ResultsTable by title
function getResultsTableByTitle(title) {
    var window = WindowManager.getWindow(title);
    if (window != null && window instanceof TextWindow) {
        var textPanel = window.getTextPanel();
        var headers = textPanel.getColumnHeadings().split("\t");
        var rows = textPanel.getLineCount();
        
        var rt = new ResultsTable();
        
        for (var i = 0; i < rows; i++) {
            var line = textPanel.getLine(i).split("\t");
            rt.incrementCounter();
            for (var j = 0; j < headers.length; j++) {
                rt.addValue(headers[j], parseFloat(line[j]));
            }
        }
        return rt;
    }
    return null;
}

var windowTitles = WindowManager.getNonImageTitles();

if (windowTitles.length == 0) {
    print("No results tables are open.");
} else {
    var continueScript = true;
    while (continueScript) {
        var gdTable = new GenericDialog("Select Results Table");
        gdTable.addChoice("Select results table:", windowTitles, windowTitles[0]);
        gdTable.showDialog();

        if (gdTable.wasCanceled()) {
            print("Script canceled by user.");
            break;
        }

        var selectedTableTitle = gdTable.getNextChoice();
        print("Selected table: " + selectedTableTitle);

        var rt = getResultsTableByTitle(selectedTableTitle);
        if (rt == null) {
            print("Error: Could not retrieve the selected results table.");
            break;
        }

        print("Number of rows in the table: " + rt.size());

        if (rt.size() == 0) {
            print("The selected results table is empty.");
            break;
        }

        var headings = rt.getHeadings();
        if (headings == null || headings.length == 0) {
            print("No columns found in the selected table.");
            break;
        }

        var gdColumns = new GenericDialog("Select Column Names");
        gdColumns.addChoice("X-axis column:", headings, "Area");
        gdColumns.addChoice("Y-axis column:", headings, "Mean");
        gdColumns.showDialog();

        if (gdColumns.wasCanceled()) {
            print("Script canceled by user.");
            break;
        }

        var xColumnName = gdColumns.getNextChoice();
        var yColumnName = gdColumns.getNextChoice();

        var xColumn = rt.getColumn(rt.getColumnIndex(xColumnName));
        var yColumn = rt.getColumn(rt.getColumnIndex(yColumnName));

        if (xColumn == null || yColumn == null) {
            var retryDialog = new GenericDialog("Column Not Found");
            retryDialog.addMessage("The specified columns were not found.\nWould you like to try again?");
            retryDialog.enableYesNoCancel("Retry", "Stop");
            retryDialog.showDialog();

            if (retryDialog.wasCanceled() || !retryDialog.wasOKed()) {
                print("Script stopped by user.");
                continueScript = false;
            } else {
                continue;
            }
        } else {
            var plot = new Plot("Plot: " + xColumnName + " vs " + yColumnName, xColumnName, yColumnName);
            plot.addPoints(xColumn, yColumn, Plot.CIRCLE);
            plot.show();

            var newPlotDialog = new GenericDialog("Create Another Plot?");
            newPlotDialog.addMessage("Do you want to create another plot?");
            newPlotDialog.enableYesNoCancel("Yes", "No");
            newPlotDialog.showDialog();

            if (newPlotDialog.wasCanceled() || !newPlotDialog.wasOKed()) {
                print("Script completed.");
                continueScript = false;
            }
        }
    }
}
