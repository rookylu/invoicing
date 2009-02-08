//TODO: Ensure this code executes WITHOUT console.log...

var headers = [];
var submenus = [];

function debug() {
    if (typeof(console) != 'undefined') {
	logDebug.apply(this, arguments);
    }
}

/*function expandSubmenu(event) {
    event.preventDefault();
    var target = event.target();
    debug("Event: ", event.target());
    
    
}

function menuHeader(header) {
    debug("H4: ", header);
    var a_link = getFirstElementByTagAndClassName("a", null, header);
    debug("a_links: ", a_link);
    connect(a_link, "onclick", expandSubmenu);
}*/

function menuConnector(idx) {
    var a_link = getFirstElementByTagAndClassName("a", null, headers[idx]);
    //debug("a_links: ", a_link);
    connect(a_link, "onclick", partial(function(idx,event) {
	event.preventDefault();
	var target = event.target();
	var options = {duration: 0.5, transition: MochiKit.Visual.Transitions.linear}
	//debug("Event: ", event.target());
	for (var sub in submenus) {
	    var style = getNodeAttribute(submenus[sub],'style');
	    style = style.replace(" ","");
	    var displayTest = /display:none/;
	    if (idx == sub)
		blindDown(submenus[sub], options);
	    else if ((style != null) && (!displayTest.test(style)))
		blindUp(submenus[sub], options);
	}
    },idx));
}

/*function connectLink(header) {
    debug("Header: ", header);
    var div_parent = getFirstParentByTagAndClassName(header, "div");
    debug("DivParent: ", div_parent);
    headers = getElementsByTagAndClassName("h4", null, div_parent);
    //map(menuHeader, headers);
    debug("There are ", headers.length, " headers");
    debug("There are ", submenus.length, " submenus");
    if (headers.length == submenus.length) {
	for (var h_idx in headers) {
	    menuConnector(h_idx);
	}
    } else {
	debug("There are different numbers of headers to submenus");
    }
}*/

function initMenu() {
    headers = getElementsByTagAndClassName("h4", "menuheader", $('menu'));
    submenus = getElementsByTagAndClassName("ul", "submenu", $('menu'));
    debug("There are ", headers.length, " headers");
    debug("There are ", submenus.length, " submenus");
    if (headers.length == submenus.length) {
	for (var h_idx in headers) {
	    menuConnector(h_idx);
	}
    } else {
	debug("There are different numbers of headers to submenus");
    }
    map(hideElement, submenus);
    //map(connectLink, headers);
}

addLoadEvent(initMenu)