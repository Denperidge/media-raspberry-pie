// Set your own preffered categories!
var sonarrCategories = "5000,5030,5040";
var sonarrAnimeCategories = "5000,5030,5040,5070";

var radarrCategories = "2000,2010,2020,2030,2035,2040,2045,2050,2060,5070";
var radarrAnimeCategories = "2000,2010,2020,2030,2035,2040,2045,2050,2060,5070";

var apikey = "YOUR_JACKETT_API_KEY";

// Add as many indexers as you want!
var indexers = [
    ["Name_you_would_like_to_call_it", "torznab_url"],
    ["Name_you_would_like_to_call_it_of_another_indexer", "torznab_url_of_another_indexer"],
]

// The script waits 1500ms between action to give your sonarr/radarr server a breather
// If you feel like that's too much or too little, feel free to change it!
var timeout = 1500;

// That's all the configuration done! The code below will handle the rest.

var categories; var animeCategories; var apikey;


if (document.title.toLowerCase().indexOf("radarr") != -1) {
    categories = radarrCategories;
    animeCategories = radarrAnimeCategories;
} else {
    categories = sonarrCategories;
    animeCategories = sonarrAnimeCategories;
}

// In case the user isn't on the correct tab yet
var indexerTab = $(".x-indexers-tab");
indexerTab.click();


// Get the correct add button
var addButton = $("#x-indexers-region").find(".indexer-item.thingy.add-card.x-add-card");


function addIndexer() {
    // Continue if there's indexers yet to be added
    if (indexers.length > 0) {
        setTimeout(indexerFirstForm, timeout);
    }
}


// The default screen: overfiew of indexers
function indexerFirstForm() {
    // Press the add button
    addButton.click();
    setTimeout(indexerSecondForm, timeout);
}

// The screen after pressing add: which preset to select
function indexerSecondForm() {
    // torznab custom
    var customTorznabButton = $(".add-thingy:contains('Torznab')").parent().find(".btn.x-custom");
    customTorznabButton.click()
    setTimeout(indexerThirdForm, timeout);
}

// The last screen: entering information and pressing save
function indexerThirdForm(indexer) {
    // Remove next indexer from the array and save it
    var indexer = indexers.shift();
    var name = indexer[0];
    var url = indexer[1];


    // Get all form inputs and put the data in them
    var formInputs = $(".indexer-modal .form-control");

    formInputs[0].value = name;
    formInputs[1].value = url;
    formInputs[3].value = apikey;
    
    formInputs[4].value = categories;
    formInputs[5].value = animeCategories;

    // Trigger the change event
    $(formInputs).change();

    setTimeout(indexerSave, timeout);
}

function indexerSave() {
    var saveButton = $(".modal-footer .x-save");
    saveButton.click();

    setTimeout(addIndexer, timeout);
}

addIndexer();