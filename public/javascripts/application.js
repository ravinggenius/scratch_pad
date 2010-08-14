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
