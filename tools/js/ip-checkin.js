// Checkin the income ip and broadcast it across the whole world to whoever provides the matched key url

const http = require("http") 
const fs = require("fs")

const server = new http.createServer()


fs.exists("ips/", r => {
    if (r)
	console.log("Found record dir /ips/")
    else
	fs.mkdir("ips", e => console.log(e))
})
	

server.on("request", (req, res) => {
    res.writeHead(200, {"Content-Type": "text/plain"})
    var reqList = req.url.split("/").filter(s => s.length > 0).filter(s => s != "ip-checkin")
    // 若是 nginx 转发，应有此种 header； 否则，源地址在 req.socket 中。
    var uip = req.headers["x-real-ip"] || req.socket.remoteAddress 
    if (reqList.lastIndexOf("update") > 0) {
	var user = reqList[0]
	fs.writeFile( "./ips/" + user + ".txt", uip, "utf-8", (e) => console.log("update: ", user, uip, e))
	res.end( user + "'s ip updated to: " + uip )
	return
    }
    else if (reqList.length > 0) {
	var user = reqList[0]
	fs.readFile("./ips/" + user + ".txt", "utf-8", (e, d) => {
	    console.log("get:", user, d, e, "by: ", uip)
	    if (e) res.end("Error to: " + uip + "\n Found nothing resembling: " + user)
	    else res.end(d)
	})
	return
    }
    else {
	res.end("No comment in response to " + uip)
    }
}).listen(5678, "127.0.0.1")
	  
console.log("listening from localhost:5678")
