$.material.init();

$('#header-search').autocomplete({
    onSelect: function (sn) { goToPath(sn.data); },
    //formatResult: function(sn, searchVal) {
      //return sn.value;
      // sn = sn || {};
      // var name = (sn.value|| "").replace(searchVal,"<strong>"+searchVal+"</strong>");
      // var desc = (sn.desc || "").replace(searchVal,"<strong>"+searchVal+"</strong>");
      // var pic_url = sn.pic_url || window.data.DEFAULT_PROFILE_PIC_URL_JS;
      // var followersWord = window.data.ui_texts.followers || "followers";
      // var num_following_me = sn.num_following_me;
      // var imgPart  = "<img src='"+pic_url+"'>"

      // var namePart = "<div class='name'>"+name+"</div>";
      // var followingPart = num_following_me ? "<span class='followers'>"+num_following_me+" "+followersWord+" · </span>" : "";
      // var descPart = "<span class='desc'>"+desc+"</span>";
      // var res      = imgPart+namePart+followingPart+descPart;
      // return res;
    //},
    serviceUrl: '/search_ajax',
});
      
$(document).ready(function($) {
  $('.my-slider').unslider({infinite: 'true', arrows: true});
});

console.log("done running main.js");