const http = require('http');
const serialPort = require('serialport')

const PORT = 12345;
const HOST = 'localhost';
const COM = 'COM8';
http.createServer((req, res) => {
    doGet(req.url, res);
}).listen(PORT, HOST, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`)
});

const port = new serialPort(`${COM}`, { baudRate: 9600 })
port.on('open', () => {
    console.log(`${COM} open`);
});

function doGet(url, res) {
    res.writeHead(200)
    var cmdStr = decodeURI(url);
    var cmdArr = cmdStr.split("/");
    if(cmdArr[1] != 'poll') {
        console.log(cmdArr)
        console.log('Handling request')
        if(cmdArr[1] == 'led_switch') {
            port.write(`${cmdArr[2]}:${cmdArr[3]}`);
        }
    }
    res.end();
}
