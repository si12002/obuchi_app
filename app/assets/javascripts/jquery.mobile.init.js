// jQuery Mobileの初期設定
jQuery(document).on('mobileinit', function () {
    jQuery.extend(jQuery.mobile, {
        loadingMessage: 'ロード中',
        pageLoadErrorMessage: 'ページの読み込みに失敗しました',
        ajaxEnabled: false
    });
});