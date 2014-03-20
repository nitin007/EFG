(function($) {
  $.fn.dashboardWidgets = function() {
    $(".pie").peity("pie")
  }
})(jQuery)

$(document).ready(function() {
  $('.dashboard').dashboardWidgets()
})
