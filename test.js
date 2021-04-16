const http = require('http');

const PORT = 12345;
const HOST = 'localhost';

http.createServer((req, res) => {
    doGet(req.url, res);
}).listen(PORT, HOST, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`)
});
function doGet(url, res) {
    res.writeHead(200);
    msg = decodeURI(url).split('/');
    console.log(msg);
    res.end();
}