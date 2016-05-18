$.material.init();

$('#header-search').autocomplete({
    onSelect: function (sn) { goToPath(sn.data); },
    serviceUrl: '/search_ajax',
});

console.log("done running main.js");