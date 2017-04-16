// https://github.com/erikdahlstrand/shrine-rails-example/blob/master/app/assets/javascripts/application.js

$(document).on("turbolinks:load", function() {
  var bind_all_event_listeners = function() {
    UnobtrusiveFlash.flashOptions['timeout'] = 8000; // milliseconds
    bind_file_upload();
    bind_submit_button();
  };

  var bind_submit_button = function(image, params_key) {
    $($(".submit_button")).off().on("click", function(event) {
      event.preventDefault();

      var $form = $("form[data='upload-form']");
      var form_data = new FormData($form[0]);

      form_data.append(params_key, JSON.stringify(image));
      $.ajax($form.attr("action"), {
        contentType: false,
        processData: false,
        data:        form_data,
        method:      $form.attr("method"),
        dataType:    "script",
        success:     function() {
          bind_all_event_listeners();
        }
      });
    });
  };

  var insert_image_into_dom = function(image) {
    if (location.hostname === "durrellsnetflix.herokuapp.com") {
      var src1 = "https://durrells-myflix-staging.s3-us-west-1.amazonaws.com/cache/" + image.id;
      $(".video .custom_thumb").append("<img src='" + src1 + "'>");
    } else if (location.hostname === "durrellsnetflixstaging.herokuapp.com") {
      var src2 = "https://durrells-myflix-staging.s3-us-west-1.amazonaws.com/cache" + image.id;
      $(".video .custom_thumb").append("<img src='" + src2 + "'>");
    } else {
      var src3 = "https://durrells-myflix-development.s3-us-west-1.amazonaws.com/cache/" + image.id;
      $(".video .custom_thumb").append("<img src='" + src3 + "'>");
    }
  };

  var bind_file_upload = function() {
    $("[type=file]").fileupload({
      add: function(e, data) {
        $(".video .custom_thumb img").remove();
        data.progressBar = $("<div class='progress progress-striped active' style='width: 200px'><div class='progress-bar progress-bar-danger' role='progressbar'></div></div>").insertAfter("form[data='upload-form']");
        var options = {
          extension: data.files[0].name.match(/(\.\w+)?$/)[0], // set extension
          _: Date.now(),                                       // prevent caching
        };
        $.getJSON("/images/cache/presign", options, function(result) {
          data.formData = result["fields"];
          data.url = result["url"];
          data.paramName = "file";
          data.submit();
        });
      },
      progress: function(e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        var percentage = progress.toString() + "%";
        data.progressBar.find(".progress-bar").css("width", percentage).html(percentage);
      },
      done: function(e, data) {
        var params_key = $(this).attr("name");
        var image = {
          id: data.formData.key.match(/cache\/(.+)/)[1], // we have to remove the prefix part
          storage: "cache",
          metadata: {
            size:      data.files[0].size,
            filename:  data.files[0].name.match(/[^\/\\]*$/)[0], // IE returns full path
            mime_type: data.files[0].type
          }
        };

        data.progressBar.remove();
        insert_image_into_dom(image);
        bind_submit_button(image, params_key);
      }
    });
  };

  bind_all_event_listeners();
});
