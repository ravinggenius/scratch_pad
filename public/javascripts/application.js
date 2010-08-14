var scratchPad;

$(document).ready(function () {
  var _sp = {
    helpers: {
      flash: {
        add: function (level, messages) {
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
            list.append('<li class="dynamic">' + message + '</li>');
          });
        },
        reset: function (level) {
          $('#flash .' + level).find('.dynamic').remove();
        },
        clearAll: function (level) {
          $('#flash .' + level).remove();
        }
      }
    }
  };

  scratchPad = {
    helpers: {
      flash: {
        error: {
          add: function (messages) {
            _sp.helpers.flash.add('error', messages);
          },
          reset: function () {
            _sp.helpers.flash.reset('error');
          },
          clearAll: function () {
            _sp.helpers.flash.clearAll('error');
          }
        },
        warning: {
          add: function (messages) {
            _sp.helpers.flash.add('warning', messages);
          },
          reset: function () {
            _sp.helpers.flash.reset('warning');
          },
          clearAll: function () {
            _sp.helpers.flash.clearAll('warning');
          }
        },
        notice: {
          add: function (messages) {
            _sp.helpers.flash.add('notice', messages);
          },
          reset: function () {
            _sp.helpers.flash.reset('notice');
          },
          clearAll: function () {
            _sp.helpers.flash.clearAll('notice');
          }
        },
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
        scratchPad.helpers.flash.warning.add('Invalid node type selected.');
        $('div#node_extension_fields').html('');
      }
    });
  });
});
