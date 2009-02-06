var headers = [];
var submenus = [];

function expandSubmenu(event) {
    event.preventDefault();
    var target = event.target();
    console.log("Event: ", event.target());
    
    
}

function menuHeader(header) {
    console.log("H4: ", header);
    var a_link = getFirstElementByTagAndClassName("a", null, header);
    console.log("a_links: ", a_link);
    connect(a_link, "onclick", expandSubmenu);
}

function menuConnector(idx) {
    var a_link = getFirstElementByTagAndClassName("a", null, headers[idx]);
    console.log("a_links: ", a_link);
    connect(a_link, "onclick", partial(function(idx,event) {
	event.preventDefault();
	var target = event.target();
	console.log("Event: ", event.target());
	for (var sub in submenus) {
	    if (idx == sub)
		slideDown(submenus[sub]);
	    else
		slideUp(submenus[sub]);
	}
    },idx));
}

function connectLink(header) {
    console.log("Header: ", header);
    var div_parent = getFirstParentByTagAndClassName(header, "div");
    console.log("DivParent: ", div_parent);
    headers = getElementsByTagAndClassName("h4", null, div_parent);
    //map(menuHeader, headers);
    console.log("There are ", headers.length, " headers");
    console.log("There are ", submenus.length, " submenus");
    if (headers.length == submenus.length) {
	for (var h_idx in headers) {
	    menuConnector(h_idx);
	}
    } else {
	console.log("There are different numbers of headers to submenus");
    }
}

function initMenu() {
    headers = getElementsByTagAndClassName("h4", "menuheader", $('menu'));
    submenus = getElementsByTagAndClassName("ul", "submenu", $('menu'));
    console.log("There are ", headers.length, " headers");
    console.log("There are ", submenus.length, " submenus");
    if (headers.length == submenus.length) {
	for (var h_idx in headers) {
	    menuConnector(h_idx);
	}
    } else {
	console.log("There are different numbers of headers to submenus");
    }
    map(hideElement, submenus);
    //map(connectLink, headers);
}

addLoadEvent(initMenu)