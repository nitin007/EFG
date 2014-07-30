(function($) {

  $.fn.lenderSelect = function() {
    return $(this).each(function(_, element) {
      var controlGroup = $(element)

      var selectAllCheckbox = null,
          individualCheckboxes = $([])

      // Partition the checkboxes into the one which will trigger select all
      // or select none and the ones which will get triggered.
      controlGroup.find('input[type=checkbox]').each(function(i, checkbox) {
        var checkbox = $(checkbox)

        if(checkbox.data('behaviour') == 'all-option') {
          selectAllCheckbox = checkbox
        } else {
          individualCheckboxes = individualCheckboxes.add(checkbox)
        }
      })

      // If this lender_select control group doesn't have an 'all-option'
      // checkbox then the rest is redundant.
      if(!selectAllCheckbox) { return }

      // If the selectAllCheckbox is checked, check all the individual ones, if
      // its not checked then uncheck the others.
      selectAllCheckbox.change(function() {
        var checkbox = $(this)
        individualCheckboxes.prop('checked', checkbox.is(':checked'))
      })

      // If any of the individualCheckboxes' is changed then toggle the correct
      // states for the selectAllCheckbox.
      individualCheckboxes.change(function() {
        var allChecked = true
        individualCheckboxes.each(function(_, checkbox) {
          if(!$(checkbox).is(':checked')) {
            allChecked = false
            return false
          }
        })

        selectAllCheckbox.prop('checked', allChecked)
      })
    })
  }

})(jQuery);

$(document).ready(function() {
  $('.control-group.lender_select').lenderSelect()
})