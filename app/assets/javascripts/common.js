// $(document).pjax('[data-pjax] a, a[data-pjax]', '#body-container');
Turbolinks.setProgressBarDelay(100)

jQuery(function() {
  var func = function(xhr, data) {
    return true;
  };
  var token = jQuery('meta[name="csrf-token"]').attr('content')
  jQuery.ajaxSetup({ beforeSend: func,
    headers: { 'x-csrf-token': token }
  });

  // Tooltip
  jQuery('[data-toggle="tooltip"]').tooltip()
});
