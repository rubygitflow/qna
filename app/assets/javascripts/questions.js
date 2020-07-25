$(document).on('turbolinks:load', function () {
  $('#question').on('click', '.edit-question-link', function (event) {
    event.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');
    console.log(questionId)
    $(`#edit-question-${questionId}`).removeClass('hidden');
  })

  $('#question').on('ajax:success', '.up-question-link, .down-question-link', function (e) {
    var question = e.detail[0];

    $(`#question .up-question-link`).addClass('hidden');
    $(`#question .down-question-link`).addClass('hidden');
    $(`#question .cancel-vote-question-link`).removeClass('hidden');
    $(`#question .rating`).html(question.rating);
  })

  $('#question').on('ajax:success', '.cancel-vote-question-link', function (e) {
    var question = e.detail[0];

    $(`#question .up-question-link`).removeClass('hidden');
    $(`#question .down-question-link`).removeClass('hidden');
    $(`#question .cancel-vote-question-link`).addClass('hidden');
    $(`#question .rating`).html(question.rating);
  })  
})
