var scratchPad;

$(document).ready(function () {
  var _sp = {
    helpers: {
      flash: function (level, messages) {
        var container, list;
        container = $('#flash');
        list = container.find('.' + level);
        if (list.length === 0) {
          container.append('<ul class="' + level + '"></ul>');
          list = container.find('.' + level);
        }
        if (typeof messages === 'string') {
          messages = [ messages ];
        }
        console.log(level + ': ' + messages);
        messages.forEach(function (message) {
          list.append('<li>' + message + '</li>');
        });
      }
    }
  };

  scratchPad = {
    helpers: {
      flash: {
        error: function (messages) {
          _sp.helpers.flash('error', messages);
        },
        warning: function (messages) {
          _sp.helpers.flash('warning', messages);
        },
        notice: function (messages) {
          _sp.helpers.flash('notice', messages);
        }
      },
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
