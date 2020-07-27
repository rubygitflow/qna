$(document).on('turbolinks:load', function () {
  const questionsList = $('.questions-list')

  $('#question').on('click', '.edit-question-link', function (event) {
    event.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');

    $(`#edit-question-${questionId}`).removeClass('hidden');
  })

  if (questionsList.length) {
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: function () {
          this.perform("follow")
      },
      received: function (data) {
          questionsList.append(JST["templates/question"](JSON.parse(data)))
      }
    })
  }
})
