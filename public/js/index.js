
$(function(){
    $('input#go').click(function(){
        var tag = $('input#tag').val();
        if(tag.length < 1) return;
        var url = app_root + '/tag/' + tag + '.rss';
        location.href = url;
    });
});