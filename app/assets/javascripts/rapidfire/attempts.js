$(document).on('turbolinks:load', function() {
  $('.fn-question-attempt input, .fn-question-attempt select').on('change',function(){
    getConditional(this);
  });


  function getConditional(input){
    id = $(input).parents('div').attr('data-question')
    path = window.location.pathname;
    $.post( path.substring(0, path.indexOf('/attempts')) + '/questions/' + id + '/conditional', function( data ) {
      $.each(data.questions, function (i, conditional) {
          check_conditional(conditional,input);
      });
    })
  }

  function check_conditional(conditional, input){
    value = $(input).val();
    $.each(conditional.question_group.question_ids, function (i, id) {
      question = $('.fn-question-attempt[data-question="' + id + '"]');

      if(apply_action(value, conditional.value, conditional.condition, input.checked)){
        if(conditional.action == 'show'){
          question.show();
        }
        else{
          question.hide();
        }
      }
      else{
        if(conditional.action == 'hide'){
          question.show();
        }
        else{
          question.hide();
        }
      }
    });

  }

  function apply_action(orig_value, dest_value, condition, is_checked){
    if (is_checked == false)
      return false

    if(condition == 'is')
      return orig_value == dest_value

    else if(condition == 'is_not')
      return orig_value != dest_value

    else if(condition == 'is_empty')
      return orig_value == ''

    else if(condition == 'is_not_empty')
      return orig_value != ''

  }

});
