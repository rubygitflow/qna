$(document).on('turbolinks:load', function () {
  const questionsList = $('.questions-list')
  const $question = $('.question')

  $question.on('click', '.edit-question-link', function (event) {
    event.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');

    $(`#edit-question-${questionId}`).removeClass('hidden');
  })

  function templatesQuestion(data) {
    return `    <li> 
      <a href="/questions/${data.id}"> ${data.title} </a>
    </li>`;
  }

  if (questionsList.length) {
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: function () {
        this.perform("follow")
      },
      received: function (data) {
        if (gon.user_id !== data.user_id){
          questionsList.append( templatesQuestion(data.question) );
        }
      }
    })
  }


  function templatesAnswer(data) {
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals
    return `    <blockquote id='answer-${data.id}'> 
      <p>  ${data.body} </p>
      <div id='vote-answer-${data.id}'>
        <p>  
          <span>  Rating: </span> 
          <span class='rating'> 0 </span> 
        </p>
        <p>  
          <span>  
            <a class='down-link btn btn-warning rounded-circle' 
              data-remote='true' rel='nofollow' data-method='post' 
              href='/answers/${data.id}/down'> 
              Down!
            </a>
            <a class='up-link btn btn-success rounded-circle' 
              data-remote='true' rel='nofollow' data-method='post' 
              href='/answers/${data.id}/up'> 
              Up!
            </a>
            <a class='cancel-vote-link btn btn-info rounded-circle hidden' 
              data-remote='true' rel='nofollow' data-method='post' 
              href='/answers/${data.id}/cancel'> 
              Cancel vote
            </a>
          </span> 
        </p>
      </div>  
    </blockquote>`;
  }


  if ($question.length) {
    const questionId = $question.data('questionId')

    App.cable.subscriptions.create('AnswersChannel', {
      connected: function () {
        this.perform("follow", {question_id: questionId})
      },
      received: function (data) {
        if (gon.user_id !== data.user_id){
          $('.answers').append( templatesAnswer(data) );
        }
      }
    })
  }
})
