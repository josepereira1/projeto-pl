function beginHTML(t){
	return "<html><head><meta charset='UTF-8'/></head><body><h1>" t "</h1>"
}


function endHTML(){
	return "</body></html>"
}


function listItem(text){
	return "<li>" text "</li><br>"
}


function link(href, text){
	return "<li><a href=" href ">" text "</a></li>"
}


function createHTMLdir() {
	system("rm -f -r html/")
	system("mkdir html/")
}