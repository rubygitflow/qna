$(document).on('turbolinks:load', function () {

  function casel_vote(resourse) {
    const parent_elem = `#vote-` + resourse.type + `-` + resourse.id;
    $(parent_elem + ` .up-link`).addClass('hidden');
    $(parent_elem + ` .down-link`).addClass('hidden');
    $(parent_elem + ` .cancel-vote-link`).removeClass('hidden');
    $(parent_elem + ` .rating`).html(resourse.rating);
  }

  function start_vote(resourse) {
    const parent_elem = `#vote-` + resourse.type + `-` + resourse.id;
    $(parent_elem + ` .up-link`).removeClass('hidden');
    $(parent_elem + ` .down-link`).removeClass('hidden');
    $(parent_elem + ` .cancel-vote-link`).addClass('hidden');
    $(parent_elem + ` .rating`).html(resourse.rating);
  }

  $('#vouting').on('ajax:success', '.up-link, .down-link', function (e) {
    var resourse = e.detail[0];
    casel_vote(resourse);
  })

  $('#vouting').on('ajax:success', '.cancel-vote-link', function (e) {
    var resourse = e.detail[0];
    start_vote(resourse);
  })  
})
