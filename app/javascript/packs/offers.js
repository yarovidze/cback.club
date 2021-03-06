
document.addEventListener('turbolinks:load', function () {
  $(document).ready(function () {
    $.ajax({
      url: "/autocomplete",
      dataType: 'JSON',
      success: function (data) {
        $('[data-behavior="autocomplete"]').easyAutocomplete({
          data: data,
          list: {
            match: {
              enabled: true
            }
          }
        });
      }
    });
  });
});