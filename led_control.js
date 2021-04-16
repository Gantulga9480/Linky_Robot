const spawn = require('child_process').spawn;
const http = require('http');
const serialPort = require('serialport')

const child = spawn('python', ['app.py']);
process.stdin.pipe(child.stdin);
child.stdout.on('data', data => {
    console.log(data.toString());
});

const PORT = 12345;
const HOST = 'localhost';
const LED = 1;
const MOTOR = 2;
var COM = 'COM8';
var baudRate = 9600;
var port = null;
var is_robot_conn = false;
var is_scratch_conn = false;
http.createServer((req, res) => {
    doGet(req.url, res);
}).listen(PORT, HOST, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`)
});

var sensorData1 = 'sensorData/1 0\n';
var sensorData2 = 'sensorData/2 0\n';
var sensorData3 = 'sensorData/3 0\n';
const ByteLenght = serialPort.parsers.ByteLength;
var parser = NaN;
function doGet(url, res) {
    res.writeHead(200);
    let cmdStr = decodeURI(url);
    let cmdArr = cmdStr.split("/");
    if(cmdArr[1] == 'start') {
        console.log('starting');
        console.log(cmdArr);
    }
    else if(cmdArr[1] == 'port') {
        console.log('port select');
        if(port == null) {
            COM = cmdArr[2];
            baudRate = parseInt(cmdArr[3]);
            console.log(cmdArr);
            port = new serialPort(`${COM}`, { baudRate: baudRate })
            port.on('open', () => {
                console.log(`${COM} OPEN`);
            });
            parser = port.pipe(new ByteLenght({length: 10}));
            parser.on('data', (data) => serialData(data));
        }
    }
    else if(cmdArr[1] == 'refresh') {
        is_scratch_conn = false;
        is_robot_conn = false;
    }
    else if(cmdArr[1] == 'status') {
        let resd = `${is_scratch_conn}/${is_robot_conn}`
        res.write(resd);
    }
    else if(cmdArr[1] != 'poll') {
        if(port != null) {
            let len = cmdArr[2].length + cmdArr[3].length
            if(cmdArr[1] == 'led_switch') {
                port.write(`${LED}`);
                port.write(`${len}`);
                port.write(`${cmdArr[2]}`);
                port.write(`${cmdArr[3]}`);
            }
            else if(cmdArr[1] == 'motor_control') {
                port.write(`${MOTOR}`);
                port.write(`${5}`); // msg len
                port.write(`${cmdArr[2]}`);
                port.write(`${cmdArr[3]}`);
                port.write(`${cmdArr[4]}`);
            }
        }
    }
    else if(cmdArr[1] == 'poll') {
        is_scratch_conn = true;
        res.write(sensorData1);
        res.write(sensorData2);
        res.write(sensorData3);
    }
    res.end();
}
function serialData(data) {
    is_robot_conn = true;
    if(data[0] == 115) {
        sensorData1 = ('sensorData/'+(data[1] - 48).toString()+' '+(data[2] - 48).toString()+'\n');
    }
    if(data[3] == 115) {
        sensorData2 = ('sensorData/'+(data[4] - 48).toString()+' '+(data[5] - 48).toString()+'\n');
    }
    if(data[6] == 115) {
        sensorData3 = ('sensorData/'+(data[7] - 48).toString()+' '+(data[8] - 48).toString()+'\n');
    }
}