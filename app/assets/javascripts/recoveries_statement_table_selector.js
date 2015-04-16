//= require accounting

(function ($) {
  $.fn.selectableRows = function () {
    var realisedDesignation = 'data-selected',
        postClaimDesignation = 'data-post-claim',
        realisedSelector = 'input[type=checkbox][id$=realised]'
        postClaimSelector = 'input[type=checkbox][id$=post_claim_limit]'

    return $(this).each(function (idx, tableElement) {
      var table = $(tableElement)

      var toggleSelection = function(selector, data_attribute) {
        var row = $(selector).parents('tr');
        var checked = $(selector).is(':checked');
        if (checked) {
          row.attr(data_attribute, 'true')
        } else {
          row.removeAttr(data_attribute)
        }
        table.trigger('rowSelect', row)
        table.trigger('rowSelectionChange')
      }

      table.on('change', realisedSelector, function () {
        toggleSelection(this, realisedDesignation)
      })

      table.on('change', postClaimSelector, function () {
        toggleSelection(this, postClaimDesignation)
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

    var totalAmount = 0;
    selector.find('[data-amount]').each(function(_, inputElement) {
      var input = $(inputElement);
      var amountText = input.attr('data-amount') || input.val();
      var amount = accounting.unformat(amountText);
      totalAmount += amount;
    });
    return totalAmount
  }

  $.fn.calculateTotals = function() {
    function setupBehaviour(table) {
      function renderTotals () {
        // calculate subtotals for this table
        var postSubTotal = table.total('tbody tr[data-selected][data-post-claim]')
        var formattedPostSubTotal = accounting.formatMoney(postSubTotal, '£')
        table.find('[data-behaviour=postSubTotal] td').text(formattedPostSubTotal)

        var subTotal = table.total('tbody tr[data-selected]')
        var formattedSubTotal = accounting.formatMoney(subTotal, '£')
        table.find('[data-behaviour=subtotal] td').text(formattedSubTotal)

        var preSubTotal = subTotal - postSubTotal
        var formattedPreSubTotal = accounting.formatMoney(preSubTotal, '£')
        table.find('[data-behaviour=preSubTotal] td').text(formattedPreSubTotal)

        // recalculate the grand totals for all tables
        var postTotal = $('table tbody tr[data-selected][data-post-claim]').total()
        var formattedPostTotal = accounting.formatMoney(postTotal, '£')
        $('[data-behaviour=post-total]').text(formattedPostTotal)

        var grandTotal = $('table tbody tr[data-selected]').total()
        var formattedGrandTotal = accounting.formatMoney(grandTotal, '£')
        $('[data-behaviour=grand-total]').text(formattedGrandTotal)

        var preTotal = grandTotal - postTotal
        var formattedPreTotal = accounting.formatMoney(preTotal, '£')
        $('[data-behaviour=pre-total]').text(formattedPreTotal)
      }

      table
        .bind('rowSelectionChange', renderTotals)
        .bind('recalculate', renderTotals)

      renderTotals()
    }

    return $(this).each(function (_, table) {
      setupBehaviour($(table))
    })
  }
})(jQuery);

$(document).ready(function() {

  function highlightRow(evt, rowElement) {
    var row = $(rowElement)
    row.toggleClass('info', !!row.attr('data-selected'))
  }

  $('[data-behaviour=recoveries-statement-table]')
    .selectableRows()
    .calculateTotals()
    .bind('rowSelect', highlightRow)

});
