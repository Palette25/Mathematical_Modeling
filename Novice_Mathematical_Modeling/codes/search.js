//找到网页上所有的超链接
var all_alink = document.getElementsByTagName("a");
//定义10个的网页集合
var webpages = ['http://www.sysu.edu.cn/2012/cn/index.htm', 'http://uems.sysu.edu.cn/jwxt/', 'http://wjw.sysu.edu.cn/',
				'http://library.sysu.edu.cn/', 'http://jwb.sysu.edu.cn/', 
				'http://tieba.baidu.com/f?kw=%D6%D0%C9%BD%B4%F3%D1%A7&fr=ala0&tpl=5',
				'http://news2.sysu.edu.cn/','http://my.sysu.edu.cn/welcome', 'http://inc.sysu.edu.cn/',
				'http://helpdesk.sysu.edu.cn/'];
//得到的结果
var result = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
//定义当前网页的order，即该网页在网页集合中的index下标
var order;

//查找过程
for(var i=0;i<all_alink.length;i++){
	if(all_alink[i].href==='/'||all_alink[i].href==='/index'
		||all_alink[i].href==='index.htm'||all_alink[i].href===webpages[order]+'index.html') result[order]++;
	else {
		for(var j=0;j<=9;j++)
			if(all_alink[i].href===webpages[j]||all_alink[i].href===webpages[j].substr(0,23)
				||all_alink[i].href===webpages[j].substr(0, webpages[j].length-1)
				||all_alink[i].href===webpages[j]+'index.htm') result[j]++;
	}
}

//存储所得到的超链接结果
var a = [];
for(var i=0;i<all_alink.length;i++)
	a.push(all_alink[i].href);