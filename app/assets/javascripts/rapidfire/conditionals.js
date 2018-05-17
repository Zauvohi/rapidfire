$(document).on('turbolinks:load', function() {
  parentQuestion = $('.fn-parent-question');
  surverId = $('#conditional_survey_id').val();
  valuesSelect = $('#conditional_value');
  questions = $('.fn-questions option');

  parentQuestion.on('change', function(){
    getValues(this.value);
    hideParentQuestion(this.value);
  });

  function getValues(id){
    if(id == ''){
      valuesSelect.html('');
    }
    else{
      path = window.location.pathname
      $.post( path.substring(0, path.indexOf('/conditionals')) + '/questions/' + id + '/values', function( data ) {
        valuesSelect.html('');
        $.each(data.values, function (i, item) {
            valuesSelect.append($('<option>', {
                value: item,
                text : item
            }));
        });
      })
    }
  }
  function hideParentQuestion(parentQuestionId){
    questions.show();

    questions.each(function() {

        if(this.value == parentQuestionId  && this.value !=  ''){
          $(this).removeAttr('selected');
          $(this).hide()
        }

    });
  }
});
