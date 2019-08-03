/**
 * 警告
 * @param	{String}	消息内容
 */
artDialog.alert = function (content, callback) {
    return artDialog({
        id: 'Alert',
        icon: 'warning',
	    opacity: 0,	// 透明度
        width: 200, //宽度,支持em等单位. 默认:'auto'
        height: 60, //高度,支持em等单位. 默认:'auto'
        fixed: true,
        lock: true,
        content: '<font style="font-family: Arial, Helvetica, sans-serif;font-size: 13px;">'+content+'</font>',
        ok: true,
        close: callback
    });
};

/**
 * 正确
 * @param	{String}	消息内容
 */
artDialog.succeed = function (content, callback) {
	if($.trim(content)=='')
		content = '操作成功！';
    return artDialog({
        id: 'Succeed',
        icon: 'succeed',        
	    opacity: 0,	// 透明度
        width: 200, //宽度,支持em等单位. 默认:'auto'
        height: 60, //高度,支持em等单位. 默认:'auto'
        fixed: true,
        lock: true,
        content: '<font style="font-family: Arial, Helvetica, sans-serif;font-size: 13px;">'+content+'</font>',
        ok: true,
        close: callback
    });
};

/**
 * 错误
 * @param	{String}	消息内容
 */
artDialog.error = function (content, callback) {
	if($.trim(content)=='')
		content = '请求失败！';
    return artDialog({
        id: 'Error',
        icon: 'error',
	    opacity: 0,	// 透明度
        width: 200, //宽度,支持em等单位. 默认:'auto'
        height: 60, //高度,支持em等单位. 默认:'auto'
        fixed: true,
        lock: true,
        content: '<font style="font-family: Arial, Helvetica, sans-serif;font-size: 13px;">'+content+'</font>',
        ok: true,
        close: callback
    });
};

/**
 * 确认
 * @param	{String}	消息内容
 * @param	{Function}	确定按钮回调函数
 * @param	{Function}	取消按钮回调函数
 */
artDialog.confirm = function (content, yes, no) {
    return artDialog({
        id: 'Confirm',
        icon: 'question',
	    opacity: 0,	// 透明度
        width: 400, //宽度,支持em等单位. 默认:'auto'
        height: 60, //高度,支持em等单位. 默认:'auto'
        fixed: true,
        lock: true,
        okVal:'是',
        cancelVal:'否',
        content: '<font style="font-family: Arial, Helvetica, sans-serif;font-size: 13px;">'+content+'</font>',
        ok: function (here) {
            return yes.call(this, here);
        },
        cancel: function (here) {
            return no && no.call(this, here);
        }
    });
};


/**
 * 提问
 * @param	{String}	提问内容
 * @param	{Function}	回调函数. 接收参数：输入值
 * @param	{String}	默认值
 */
artDialog.prompt = function (content, yes, value) {
    value = value || '';
    var input;
    
    return artDialog({
        id: 'Prompt',
        icon: 'question',
	    opacity: 0,	// 透明度
        width: 200, //宽度,支持em等单位. 默认:'auto'
        height: 60, //高度,支持em等单位. 默认:'auto'
        fixed: true,
        lock: true,
        content: [
            '<div style="margin-bottom:5px;font-size:12px">',
                content,
            '</div>',
            '<div>',
                '<input value="',
                    value,
                '" style="width:18em;padding:6px 4px" />',
            '</div>'
            ].join(''),
        init: function () {
            input = this.DOM.content.find('input')[0];
            input.select();
            input.focus();
        },
        ok: function (here) {
            return yes && yes.call(this, input.value, here);
        },
        cancel: true
    });
};


/**
 * 短暂提示
 * @param	{String}	提示内容
 * @param	{Number}	显示时间 (默认1.5秒)
 */
artDialog.tips = function (content, time) {
    return artDialog({
        id: 'Tips',
        title: false,
        cancel: false,
        fixed: true,
        lock: true,
	    opacity: 0	// 透明度
    })
    .content('<div style="padding: 0 1em;font-size:13px;">' + content + '</div>')
	.time(time || 1);
};

//右下角滑动通知
artDialog.notice = function (options) {
var opt = options || {},
    api, aConfig, hide, wrap, top,
    duration = 800;
    
var config = {
    id: 'Notice',
    left: '100%',
    top: '100%',
    fixed: true,
    drag: false,
    resize: false,
    follow: null,
    lock: false,
    init: function(here){
        api = this;
        aConfig = api.config;
        wrap = api.DOM.wrap;
        top = parseInt(wrap[0].style.top);
        hide = top + wrap[0].offsetHeight;
        
        wrap.css('top', hide + 'px')
            .animate({top: top + 'px'}, duration, function () {
                opt.init && opt.init.call(api, here);
            });
    },
    close: function(here){
        wrap.animate({top: hide + 'px'}, duration, function () {
                opt.close && opt.close.call(this, here);
                aConfig.close = $.noop;
                api.close();
            });
            
            return false;
        }
    };	
    
    for (var i in opt) {
        if (config[i] === undefined) config[i] = opt[i];
    };
    
    return artDialog(config);
};