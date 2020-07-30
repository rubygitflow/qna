$(document).on('turbolinks:load', function () {
  const questionsList = $('.questions-list')
  const $question = $('.question')

  $question.on('click', '.edit-question-link', function (event) {
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
        if (gon.user_id !== data.user_id){
          questionsList.append(JST["templates/question"](data))
        }
      }
    })
  }

  if ($question.length) {
    const questionId = $question.data('questionId')

    App.cable.subscriptions.create('AnswersChannel', {
      connected: function () {
        this.perform("follow", {question_id: questionId})
      },
      received: function (data) {
        if (gon.user_id !== data.user_id){
          $('.answers').append(JST["templates/answer"](data))
        }
      }
    })
  }
})
