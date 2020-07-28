document.addEventListener('turbolinks:load', () => {
  $('.add-comment-link').on('click', function (event) {
    event.preventDefault();
    const parent = $(this).parent().parent().parent();
    const near_form = parent.find('.create-comment-form');

    near_form.attr('action', $(this).data('url'));
    near_form.removeClass('hidden');
  })
});
