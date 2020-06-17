var timeout = 1500;

function Series(name) {
    name = name.toLowerCase().trim();

    var filesRaw = $(".series-title-cell.editable");
    var files = [];
    for (var i = 0; i < filesRaw.length; i++) {
        files.push(filesRaw[i]);
    }
    console.log(files)

    SeriesFirstForm(files, name)
}

function SeriesFirstForm(files, name) {
    var file = files.shift();
    file.click();
    setTimeout(function() {
        SeriesSecondForm(files, name);
    }, timeout);
}

function SeriesSecondForm(files, name) {
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

function Season(index) {
    index = parseInt(index);

    var filesRaw = $(".season-cell.sortable");
    var files = [];
    for (var i = 0; i < filesRaw.length; i++) {
        files.push(filesRaw[i]);
    }

    SeasonFirstForm(files, index)
}

function SeasonFirstForm(files, index) {
    var file = files.shift();
    file.click();
    setTimeout(function() {
        SeasonSecondForm(files, index);
    }, timeout);
}

function SeasonSecondForm(files, index) {
    var selector = $(".form-control.x-select-season")
    // Index 0 is "select season..."
    // Index 1 is season 0
    // Index 2 is season 1
    selector[0].selectedIndex = (index + 1);
    selector.change()

    setTimeout(function() {
        SeasonFirstForm(files, index);
    }, timeout);
}

function Episodes() {
    var filesRaw = $(".episodes-cell.renderable");
    var files = [];
    for (var i = 0; i < filesRaw.length; i++) {
        files.push(filesRaw[i]);
    }

    var index = 0;

    EpisodesFirstForm(files, index)
}

function EpisodesFirstForm(files, index) {
    var file = files.shift();
    file.click();
    index++;

    setTimeout(function() {
        EpisodesSecondForm(files, index);
    }, timeout);
}


function EpisodesSecondForm(files, index) {
    var episodes = $(".episode-number-cell.sortable.renderable");
    for (var i = 0; i < episodes.length; i++) {
        var episode = episodes[i];
        var episodeIndex = parseInt(episode.innerText);

        if (episodeIndex == index) {
            episode.click();
            break;
        }
    }

    $(".btn.btn-success.x-select").click();

    setTimeout(function() {
        EpisodesFirstForm(files, index);
    }, timeout);
}

// Example usage:
// Series("kids next door");
// Season(1)
// Episodes();