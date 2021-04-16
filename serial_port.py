import serial

class SerialPort(serial.Serial()):

    def __init__(self) -> None:
        super().__init__()

    def __init__(self, port='COM8', baudrate=9600, timeout=0) -> None:
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout

    def open(self):
        self.serial.open()
        print('Port opened')

    def close(self):
        self.serial.close()
        print('Port closed')

    def write(self, msg):
        self.serial.write(bytes(msg, 'utf-8'))

    def read(self):
        return self.serial.read()