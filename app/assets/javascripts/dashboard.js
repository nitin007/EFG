(function($) {
  $.fn.dashboardWidgets = function() {
    $(".pie").peity("pie")
    $('.loan-alert span').tooltip()
  }
})(jQuery)

$(document).ready(function() {
  $('.dashboard').dashboardWidgets()
})
