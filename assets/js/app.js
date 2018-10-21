// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(function () {
    var start = 0;
    $('#start-working-button').click((ev) => {
        start = new Date();
    });
    $('#stop-working-button').click((ev) => {
        if (start != 0) {
            let end = new Date();
            let task_id = $(ev.target).data('task-id');
            let csrf_token = $("meta[name='csrf-token']").attr("content");
            console.log(csrf_token);
            let text = JSON.stringify({
                time_block: {
                    task_id: task_id.toString(),
                    start: start,
                    end: end,
                },
            });

            $.ajax(time_block_path, {
                method: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("X-CSRF-Token", csrf_token);
                },
                contentType: "application/json; charset=UTF-8",
                data: text,
                success: (resp) => {
                    location.reload()
                },
            });
            start = 0;
        }
    });
});
