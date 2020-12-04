// $(document).pjax('[data-pjax] a, a[data-pjax]', '#body-container');
Turbolinks.setProgressBarDelay(100)

jQuery(document).ready(function() {
  var func = function(xhr, data) {
      return true;
  };
  var token = jQuery('meta[name="csrf-token"]').attr('content')
  jQuery.ajaxSetup({ beforeSend: func,
    headers: { 'x-csrf-token': token }
  });
});


// Modal Specific code