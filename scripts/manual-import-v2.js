var timeout = 1500;
var seasonIndex = 0, episodesIndex = 0;  // Where the season/episodes processor is at the moment


// Handle file to modify
function FilesForm(calledFrom, identifier, amountOfFiles) {
    // calledFrom is which function this is called from (aka what value to modify)
    // identifier is either the series name, or the season index
    // amountOfFiles is which amount of files to apply this to. Mainly used in folders with multiple seasons in one
    var fileSelector;

    switch(calledFrom) {
        case Series:
            fileSelector = ".series-title-cell.editable";
    }

    var filesRaw = $(fileSelector);
    var files = [];
    for (var i = 0; i < filesRaw.length; i++) {
        files.push(filesRaw[i]);
    }

}

function SeriesForm(files, name) {
    var series = $(".select-row.select-series-row");
    for (var i = 0; i < series.length; i++) {
        var currentSeries = series[i];
        var seriesTitle = currentSeries.innerText.toLowerCase();
        if (seriesTitle.indexOf(name) > -1) {
            currentSeries.click();
            break;
        }
    }

    setTimeout(function() {
        SeriesFirstForm(files, name);
    }, timeout);
}


// This function will be used by the user
// Only one argument is necessary, since a mix of series in one folder doesn't usually happen 
function Series(seriesName) {
    seriesName = seriesName.toLowerCase().trim();
    FilesForm(Series, seriesName, -1);
}