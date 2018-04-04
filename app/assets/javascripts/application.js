// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//



//= require jquery
//= require jquery_ujs
//= require jquery-ui
// require turbolinks
//= require_tree .

$(function(){
    // $(document).foundation();
    const author_ids = [];
    function async_update() {
        setTimeout(
            function () {
                $("#author-search").val("");
                $("#author_ids").val(
                    $("#authors li").toArray().reduce(
                        function(m,e) {
                            return m + $(e).attr("id") + ","
                        },
                        ""));
            },
            0);
    }

    $(".date-picker").datepicker();

    $('input#author-search').autocomplete({
        source: "/authors",
        minLength: 3,
        select: function(event,ui) {
            if (ui.item.id === -1 || author_ids.indexOf(ui.item.id) > -1) {
                event.preventDefault();
                return false;
            } else {
                $('#authors').append("<li id='" + ui.item.id + "'>" + ui.item.label + "</li>");
                author_ids.push(ui.item.id);
                async_update();
            }
        }

    });
    $("#authors").on("click", "li", function (evt) {
        const idx = author_ids.indexOf(parseInt($(evt.target).attr("id")));
        if (idx > -1) {
            author_ids.splice(idx,1);
        }
        $(evt.target).remove();
        async_update();
    })
});
