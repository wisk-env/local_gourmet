$(document).on('turbo:load', function() {
  $(function() {
    $('.tab').on("click", function() {
      $('.tab-active').removeClass('tab-active');
      $(this).addClass('tab-active');
      $('.active-contents').removeClass('active-contents');
      const index = $(this).index();
      $('.tab-contents').eq(index).addClass('active-contents');
    });
  });
});
