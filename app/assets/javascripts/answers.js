$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
      e.preventDefault();
      $(this).hide();
      var answerId = $(this).data('answerId');
      
      $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.answer_like').on('ajax:success', function (e) {
    var vote = e.detail[0];

    $('.answer_rating_' + vote['id']).html('<b>' + vote['rating'] + '</b>');
  });
});
