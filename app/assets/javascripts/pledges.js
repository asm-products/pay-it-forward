var pledge_js = function() {
  $('#pledge-options').click(function () {
    $('#pledge-adjust').toggle();
  });
};

$(document).ready(pledge_js);
$(document).on('page:load', pledge_js);