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

  $.fn.total = function (filter) {
    var selector
    if(filter) {
      selector = $(filter, this)
    } else {
      selector = $(this)
    }

    var totalAmountSettled = 0;
    selector.find('[data-amount]').each(function(_, input) {
      var input = $(input);
      var amountSettledText = input.attr('data-amount') || input.val()
      var amountSettled = parseFloat(amountSettledText, 10);
      totalAmountSettled = totalAmountSettled + amountSettled;
    });
    return totalAmountSettled
  }

  $.fn.subTotal = function() {
    function setupSubTotal(table) {
      function render () {
        var subTotal = table.total('tbody tr[data-selected]')
        var formattedSubTotal = accounting.formatMoney(subTotal, '')

        table.find('[data-behaviour^=subtotal] input').val(formattedSubTotal)
      }

      table
        .bind('rowSelectionChange', render)
        .bind('recalculate', render)

      render()
    }

    return $(this).each(function (_, table) {
      setupSubTotal($(table))
    })
  }
})(jQuery);

$(document).ready(function() {

  function highlightRow(evt, row) {
    var row = $(row)
    row.toggleClass('info', !!row.attr('data-selected'))
  }

  $('[data-behaviour^=invoice-received-table], [data-behaviour^=recoveries-statement-table]')
    .selectableRows()
    .subTotal()
    .bind('rowSelect', highlightRow)

  $('[data-behaviour^=invoice-received-table]')
    .on('blur', 'tbody input[type=text]', function() {
      $(this).parents('table').trigger('recalculate')
    })

});
