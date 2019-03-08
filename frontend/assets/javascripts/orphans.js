$(function() {

  var initImportJobForm = function() {
    var $form = $('#jobfileupload');

    var jobType;

    $(".btn:submit", $form).on("click", function(event) {
      event.stopPropagation();
      event.preventDefault();

      $form.submit();
    });

    var supportsHTML5MultipleFileInput = function() {
      var input = document.createElement("input");
      input.setAttribute("multiple", "true");
      return input.multiple === true;
    };

    $(document).ready(function() {
      $("#job_form_messages", $form).empty()

      var type = $("#job_type").val();

      if (type === "orphan_finder_job") {
        $("#job_form_messages", $form)
          .html(AS.renderTemplate("template_orphan_instructions"));
        // we disable to form...
        $('.form-actions .btn-primary').addClass('disabled');
        $("#noImportTypeSelected", $form).hide();
        $("#job_type_fields", $form)
          .empty()
          .html(AS.renderTemplate("template_orphan_finder_job", {id_path: "job_job_params_", path: "job[job_params]"}));
        $(".linker:not(.initialised)").linker();
        $(document).triggerHandler("subrecordcreated.aspace", ["date", $form]);
        $('.select-record', $form).on("click", function(event) {
          $('.accordion-toggle').click();
          $('.form-actions .btn-primary').removeClass('disabled');
          event.preventDefault();
          var orphan = $(this).data('orphan');
          var $listing = $(this).parent();
          $(this).siblings(".selected-message").removeClass("hide")
          $(this).addClass("hide")
          $listing.removeClass('alert-info').addClass('alert-success');
          $listing.parent().siblings('.orphan-listing').fadeOut('slow', function() { $(this).remove(); });
        });

        initRunTypeOrphanSubForm();
      }
    });

    var handleError = function(errorHTML) {

      $(".job-create-form-wrapper").replaceWith(errorHTML);
      initImportJobForm();
    };

    var $progress = $("#uploadProgress", $form)
    var $progressBar = $(".bar", $progress)

    $form.ajaxForm({
      type: "POST",
      beforeSubmit: function(arr, $form, options) {
        $(".btn, a, :input", $form).attr("disabled", "disabled").addClass("disabled");
        $progress.show();

	var jobType = $("#job_type").val();

        if (jobType === 'import_job') {
          console.log("ATTACH");
          $(".import-file.file-attached").each(function() {
            var $input = $(this);
            console.log($input);
            arr.push({
              name: "files[]",
              type: "file",
              value: $input.data("file")
            });
          });
        }
      },
      uploadProgress: function(event, position, total, percentComplete) {
        var percentVal = percentComplete + '%';
        $progressBar.width(percentVal)
      },
      success: function(json, status, xhr) {
        var uri_to_resolve;

        if (typeof json === "string") {
          // In IE8 (older browsers), AjaxForm will use an iframe to deliver this POST.
          // When using an iframe it cannot handle JSON as a response type... so let us
          // grab the HTML string returned and parse it.
          var $responseFromIFrame = $(json);

          if ($responseFromIFrame.is("textarea")) {
            if ($responseFromIFrame.data("type") === "html") {
              // it must of errored
              return handleError($responseFromIFrame.val());
            } else if ($responseFromIFrame.data("type") === "json") {
                uri_to_resolve = JSON.parse($responseFromIFrame.val()).uri;
            } else {
              throw "jobs.crud: textarea.data-type not currently support - " + $responseFromIFrame.data("type");
            }
          } else {
            throw "jobs.crud: the response text should be wrapped in a textarea for the plugin AjaxForm support";
          }
        } else {
          uri_to_resolve = json.uri;
        }

        var percentVal = '100%';
        $progressBar.width(percentVal)
        $progress.removeClass("active").removeClass("progress-striped");
        $progressBar.addClass("bar-success");
        $("#successMessage").show();

        location.href = AS.app_prefix("resolve/readonly?uri="+uri_to_resolve);
      },
      error: function(xhr) {
        handleError(xhr.responseText);
      }
    });
  };

  var initRunTypeOrphanSubForm = function () {
    $(document).on('change', '#orphan_finder_job_run_type', function () {

      if ($(this).val() == 'review_run') {
        $('.review_desc').show();
      } else {
        $('.review_desc').hide();
      }
      if ($(this).val() == 'execute_run') {
        $('.execute_desc').show();
      } else {
        $('.execute_desc').hide();
      }
      if ($(this).val() == 'test_run') {
        $('.test_desc').show();
      } else {
        $('.test_desc').hide();
      }
    });
  };

  initImportJobForm();
});
