$(document).on('turbolinks:load', function () {
  $('.questions').on('click', '.edit-question-link', function (e) {
      e.preventDefault();
      $(this).hide();
      var questionId = $(this).data('questionId');
      $('form#edit-question-' + questionId).removeClass('hidden');
  });

  $('.question_like').on('ajax:success', function (e) {
    var vote = e.detail[0];

    $('.question_rating').html('<b>' + vote['rating'] + '</b>');
  });
});
