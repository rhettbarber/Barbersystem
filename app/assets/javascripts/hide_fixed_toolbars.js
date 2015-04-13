console.log("-----BEGIN file hide_fixed_toolbars.js") ;


function toggleToolbarOnScroll() {
    console.log("initialize toggleToolbarOnScroll()")
    $(function(){
        var lastScrollTop = 0, delta = 5;
        $(window).scroll(function(event){
            var st = $(this).scrollTop();

            if(Math.abs(lastScrollTop - st) <= delta)
                return;

            if (st > lastScrollTop){
                // downscroll code
//                console.log('scroll down');
                $.mobile.activePage.children("[data-position='fixed']").hide();
            } else {
                // upscroll code
//                console.log('scroll up');
                $.mobile.activePage.children("[data-position='fixed']").show();
            }
            lastScrollTop = st;
        });
    });
}
