$.material.init();

$('#header-search').autocomplete({
    onSelect: function (sn) { goToPath(sn.data); },
    serviceUrl: '/search_ajax',
});
      
$(document).ready(function($) {
  $('.my-slider').unslider({infinite: 'true', arrows: true});
});

console.log("done running main.js");