// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

import "channels";
import "bootstrap";
import "jquery"
import "@popperjs/core";
import "../stylesheets/application.scss";
import "activeadmin_quill_editor";
import "@fortawesome/fontawesome-free/css/all"


require("bootstrap")
require("jquery")
require("easy-autocomplete")


require("packs/offers")
require("packs/cookies")

require.context("../images", true);
window.jQuery = $;
window.$ = $;

$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})


$(document).ready(function () {
    setTimeout(function () {
        $('#notice-wraper').fadeOut("slow", function () {
            $(this).remove();
        })
    }, 4500);
});







