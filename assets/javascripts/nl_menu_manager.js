/* Next Level™ Menu Manager — Drag-and-drop sortable UI
 * Uses jQuery UI Sortable (already loaded by Redmine globally).
 * Updates hidden position inputs on drop so the form POST reflects the new order.
 */
$(document).ready(function () {

  // Initialise all sortable menu lists
  $('.nl-menu-sortable').sortable({
    handle:      '.nl-drag-handle',
    axis:        'y',
    cursor:      'grabbing',
    placeholder: 'nl-menu-placeholder',
    tolerance:   'pointer',

    update: function (event, ui) {
      // Renumber position inputs after every drop
      $(this).find('li.nl-menu-item').each(function (index) {
        $(this).find('.nl-position-input').val(index + 1);
      });
    }
  }).disableSelection();

  // Auto-submit per-project form on checkbox change (optional convenience)
  // Commented out — let the user hit Save explicitly.
  // $('#nl-project-menu-form input[type=checkbox]').on('change', function () {
  //   $(this).closest('form').submit();
  // });

});
