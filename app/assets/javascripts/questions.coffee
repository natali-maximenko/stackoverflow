$(document).on 'turbolinks:load', ->
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

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
      ,
    received: (data) ->
      console.log(data)
      $('.questions-list').append(JST["templates/question"](data))
  });
