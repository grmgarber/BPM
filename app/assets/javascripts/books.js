$(function(){
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
