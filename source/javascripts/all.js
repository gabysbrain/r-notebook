//= require_tree .
//= require "jquery"
//= require "highlightjs"

$(document).ready(function() {
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });
});

