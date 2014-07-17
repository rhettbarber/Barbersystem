$(function() {
return $('a.load-more-posts').on('inview', function(e, visible) {
  if (!visible) {
    return;
}
return $.getScript($(this).attr('href'));
});
});