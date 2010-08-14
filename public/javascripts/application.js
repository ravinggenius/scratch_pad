var scratchPad;

$(document).ready(function () {
  var _sp = {};

  scratchPad = {
    helpers: {
      urlFor: function (namedRoute, options) {
        if (typeof options === 'undefined') {
          options = {};
        }
        if (typeof namedRoute === 'string') {
          options['named_route'] = namedRoute;
        } else if (typeof namedRoute === 'object') {
          options = namedRoute;
        }
        return $.ajax({
          type: 'GET',
          url: '/assets/routes',
          data: options,
          async: false
        }).responseText;
      }
    }
  };
});

$(document).ready(function () {
  $('select#node_type').change(function (eventObject) {
    $.ajax({
      url: scratchPad.helpers.urlFor('admin_nodes_new_node_type', {
        node_type: $(this).find('option:selected').val()
      }),
      success: function (data, textStatus, XMLHttpRequest) {
        $('div#node_extension_fields').html(data);
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        // TODO also show error message in flash
        $('div#node_extension_fields').html('');
      }
    });
  });
});
