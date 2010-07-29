var scratchPad;

$(document).ready(function () {
  var _sp = {
    helpers: {
    }
  };

  scratchPad = {
    helpers: {
      urlFor: function (namedRoute, options) {
        if (typeof options === 'undefined') {
          options = {};
        }
        if (typeof namedRoute === 'string') {
          options['namedRoute'] = namedRoute;
        } else if (typeof namedRoute === 'object') {
          options = namedRoute;
        }
        return $.ajax({
          type: 'GET',
          url: '/a/routes',
          data: options,
          async: false
        }).responseText;
      }
    }
  };

  //console.log(scratchPad.helpers.urlFor('root'));
  //console.log(scratchPad.helpers.urlFor('admin_root', {
  //  language: 'en'
  //}));
  //console.log(scratchPad.helpers.urlFor({
  //  c: 'sessions',
  //  a: 'new'
  //}));
});
