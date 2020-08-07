document.addEventListener('turbolinks:load', () => {
  $('.add-comment-link').on('click', function (event) {
    event.preventDefault();
    const parent = $(this).parent().parent().parent();
    const near_form = parent.find('.create-comment-form');

    near_form.attr('action', $(this).data('url'));
    near_form.removeClass('hidden');
  })

  const $question = $('.question');

  function templatesComment(data) {
    return `    <li id="comment-${data.id}"> ${data.body} </li>`;
  }

  if ($question.length) {
    const questionId = $question.data('questionId')

    App.cable.subscriptions.create('CommentsChannel', {
      connected: function () {
        this.perform("follow_comments", {question_id: questionId})
      },
      received: function (data) {
        if (gon.user_id !== data.user_id){
          $(`#comments-${data.commentable_type.toLowerCase()}-${data.commentable_id} .comments-list`)
            .append(templatesComment(data));
        }
      }
    })
  }
});
