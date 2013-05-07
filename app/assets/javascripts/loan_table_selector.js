//= require accounting

(function ($) {
  $.fn.selectableRows = function () {
    var dataAttribute = 'data-selected'
    var rowInputSelector = 'input[type=checkbox]'

    return $(this).each(function (idx, table) {
      var table = $(table)

      var toggleSelected = function(row) {
        var row = $(row)
        var checked = row.find(rowInputSelector).is(':checked');

        if(checked) {
          row.attr(dataAttribute, 'true')
        } else {
          row.removeAttr(dataAttribute)
        }

        table.trigger('rowSelect', row)
      }

      setTimeout(function() {
        table.find('tr').each(function(idx, row) {
          toggleSelected(row)
        })
        table.trigger('rowSelectionChange')
      })

      table.on('change', rowInputSelector, function () {
        var row = $(this).parents('tr');
        toggleSelected(row)
        table.trigger('rowSelectionChange')
      })
    })
  }

  $.fn.subTotal = function() {
    function subTotalView(table) {
      function render () {
        var subTotal = calculateSubTotal(table)
        var formattedSubTotal = accounting.formatMoney(subTotal, '')

        table.find('[data-behaviour^=subtotal] input').val(formattedSubTotal)
      }

      function calculateSubTotal() {
        var totalAmountSettled = 0;
        table.find('tbody tr[data-selected] input[type=text]').each(function(_, input) {
          var input = $(input);
          var amountSettledText = input.val();
          var amountSettled = parseFloat(amountSettledText, 10);
          totalAmountSettled = totalAmountSettled + amountSettled;
        });
        return totalAmountSettled
      }

      table
        .bind('rowSelect', render)
        .bind('recalculate', render)

      render()
    }

    return $(this).each(function (_, table) {
      subTotalView($(table))
    })
  }
})(jQuery);

$(document).ready(function() {

  function highlightRow(evt, row) {
    var row = $(row)
    row.toggleClass('info', !!row.attr('data-selected'))
  }

  $('[data-behaviour^=loan-table-selector]')
    .selectableRows()
    .subTotal()
    .bind('rowSelect', highlightRow)
    .on('blur', 'tbody input[type=text]', function() {
      $(this).parents('table').trigger('recalculate')
    })

});
