$(function() {
  var header = $('.globalHeader').outerHeight(true);
  var footer = $('.globalFooter').outerHeight(true);
  $('.globalContents').css('min-height', 'calc(100vh - ' + (header + footer) + 'px)');
});
