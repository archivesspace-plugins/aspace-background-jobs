//= require form

var init = function() {

    var $form = $('#job_form');

    var initOrphanJobForm = function() {

        $("#job_form_messages", $form)
            .html(AS.renderTemplate("template_orphan_instructions"));
        // we disable to form...
        $('.btn-primary:submit').addClass('disabled');

        $(document).triggerHandler("subrecordcreated.aspace", ["date", $form]);
        $('.select-record', $form).on("click", function(event) {
            $('.accordion-toggle').click();
            $('.btn-primary:submit').removeClass('disabled');
            event.preventDefault();
            var orphan = $(this).data('orphan');
            var $listing = $(this).parent();
            $(this).siblings(".selected-message").removeClass("hide")
            $(this).addClass("hide")
            $listing.removeClass('alert-info').addClass('alert-success');
            $listing.parent().siblings('.orphan-listing').fadeOut('slow', function() {
                $(this).remove();
            });
        });

        var initFormatOrphanSubForm = function () {
          $(document).on('change', '#job_run_type', function () {

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

        initFormatOrphanSubForm();
    };

    var type = $("#job_type").val();

    $(".linker:not(.initialised)").linker();

    // these were added because it was neccesary to get translation
    $(".translation-placeholder").remove();

    if (type == "orphan_finder_job") {
        initOrphanJobForm();
    }
};

$(init);
