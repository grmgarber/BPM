$(function(){
    const book_authors = JSON.parse($("#book-authors").val());
    function async_update() {
        setTimeout(
            function () {
                $("#author-search").val("");
                $("#author_ids").val(
                    book_authors.reduce(
                        function(m,e) {
                           return m + e.id + ","
                        }, ""
                    )
                );
            },
            0);
    }

    function book_authors_index_of(author_id) {
        return book_authors.findIndex(
            function (e) { return e.id === author_id }
        );
    }

    // $(".date-picker").datepicker();
    // $(".date-picker").datepicker("option", "dateFormat", "yy-mm-dd");

    book_authors.forEach(function(ba) {
       $("#authors").append("<li id='" + ba.id + "'>" + ba.name + "</li>")
    });
    async_update();

    $('input#author-search').autocomplete({
        source: "/authors",
        minLength: 3,
        select: function(event,ui) {
            if (ui.item.id === -1 || book_authors_index_of(ui.item.id) > -1) {
                event.preventDefault();
                return false;
            } else {
                $('#authors').append("<li id='" + ui.item.id + "'>" + ui.item.label + "</li>");
                book_authors.push({id: ui.item.id, name: ui.item.label});
                async_update();
            }
        }

    });
    $("#authors").on("click", "li", function (evt) {
        const deleted_id = parseInt($(evt.target).attr("id"));
        const idx = book_authors_index_of(deleted_id);
        if ( idx > -1) {
            book_authors.splice(idx,1);
        }

        $(evt.target).remove();
        async_update();
    })
});
