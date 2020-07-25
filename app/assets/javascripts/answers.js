$(document).on('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (event) {
    event.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $(`#edit-answer-${answerId}`).removeClass('hidden');
  })

  $('.answers').on('ajax:success', '.up-answer-link, .down-answer-link', function (e) {
    var answer = e.detail[0];

    $(`#answer-${answer.id} .cancel-vote-answer-link`).removeClass('hidden');
    $(`#answer-${answer.id} .up-answer-link`).addClass('hidden');
    $(`#answer-${answer.id} .down-answer-link`).addClass('hidden');
    $(`#answer-${answer.id} .rating`).html(answer.rating);
  })

  $('.answers').on('ajax:success', '.cancel-vote-answer-link', function (e) {
    var answer = e.detail[0];

    $(`#answer-${answer.id} .up-answer-link`).removeClass('hidden');
    $(`#answer-${answer.id} .down-answer-link`).removeClass('hidden');
    $(`#answer-${answer.id} .cancel-vote-answer-link`).addClass('hidden');
    $(`#answer-${answer.id} .rating`).html(answer.rating);
  })
})
