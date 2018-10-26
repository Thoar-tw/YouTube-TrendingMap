$(document).ready(function(){
    $('input.autocomplete').autocomplete({
      data: {
        "Taiwan": 'TW',
        "United State": 'US'
      },
    });
  });