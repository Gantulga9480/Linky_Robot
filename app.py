from tkinter import Canvas, Menu, StringVar, Tk, ttk
from tkinter.constants import DISABLED
import requests
from serial.tools import list_ports


rbt_state = False
hlp_state = True
scr_state = False
comports = list(list_ports.comports())
ports = []
baudrates = ['9600', '14400', '19200', '38400', '56000', '57600', '115200']
for item in comports:
    ports.append(str(item).split(' ')[0])


def start(port, baudrate):
    port = port.get()
    baudrate = baudrate.get()
    x = requests.get(f'http://127.0.0.1:12345/port/{port}/{baudrate}')
    if str(x).split(' ')[1] == '[200]>':
        port_btn['text'] = 'Холбогдсон'
        port_btn['state'] = DISABLED

def check_status():
    x = requests.get(f'http://127.0.0.1:12345/status')
    res = x.content.decode('utf-8').split('/')
    if res[0] == 'true':
        scr_state = True
    else:
        scr_state = False
    if res[1] == 'true':
        rbt_state = True
    else:
        rbt_state = False
    if rbt_state:
        canvas_rbt.itemconfig(rtb_oval, fill="green")
    else:
        canvas_rbt.itemconfig(rtb_oval, fill="red")
    if scr_state:
        canvas_scr.itemconfig(scr_oval, fill="green")
    else:
        canvas_scr.itemconfig(scr_oval, fill="red")
    root.after(100, check_status)

def refresh():
    requests.get(f'http://127.0.0.1:12345/refresh')


# Root window
root = Tk()
root.iconbitmap(default='apps.ico')
root.title('Холбогч')
root.resizable(False, False)
# Tk variables
port = StringVar()
baudrate = StringVar()
# Serial port frame
config_frame = ttk.LabelFrame(root, text='Цуваа портын тохирго')
config_frame.pack(fill='x')
# Labels
comlbl = ttk.Label(config_frame, text='COM портууд')
comlbl.grid(row=0, column=0, padx=5)
comlbl = ttk.Label(config_frame, text='Baudrate')
comlbl.grid(row=0, column=1, padx=5)
# Port select
menu = ttk.Combobox(config_frame, value=ports, textvariable=port)
menu.current(0)
menu.config(state="readonly", width=10)
menu.bind("<<ComboboxSelected>>")
menu.grid(row=1, column=0, padx=5, pady=5)
# Baudrate select
bmenu = ttk.Combobox(config_frame, value=baudrates, textvariable=baudrate)
bmenu.current(0)
bmenu.config(state="readonly", width=10)
bmenu.bind("<<ComboboxSelected>>")
bmenu.grid(row=1, column=1, padx=5, pady=5)
# Port connect btn
port_btn = ttk.Button(config_frame, text='Холбогдох', command=lambda: start(port, baudrate))
port_btn.grid(columnspan=2 ,row=2, column=0, padx=5, pady=5)
# Status frame
status_frame = ttk.LabelFrame(root, text='Төлөв')
status_frame.pack(fill='x')
# Status labels
rbt_lbl = ttk.Label(status_frame, text='Робот')
rbt_lbl.grid(row=0, column=0, padx=10)
hlp_lbl = ttk.Label(status_frame, text='Холбогч')
hlp_lbl.grid(row=0, column=1, padx=10)
scr_lbl = ttk.Label(status_frame, text='Scratch')
scr_lbl.grid(row=0, column=2, padx=10)\

# Status canvas
canvas_rbt = Canvas(status_frame, width=50, height=50)
canvas_rbt.grid(row=1, column=0)
canvas_hlp = Canvas(status_frame, width=50, height=50)
canvas_hlp.grid(row=1, column=1)
canvas_scr = Canvas(status_frame, width=50, height=50)
canvas_scr.grid(row=1, column=2)

# Status oval
rtb_oval = canvas_rbt.create_oval(10, 10, 40, 40)
canvas_rbt.itemconfig(rtb_oval, fill="red")
hlp_oval = canvas_hlp.create_oval(10, 10, 40, 40)
canvas_hlp.itemconfig(hlp_oval, fill="green")
scr_oval = canvas_scr.create_oval(10, 10, 40, 40)
canvas_scr.itemconfig(scr_oval, fill="red")

menubar = Menu(root)
filemenu = Menu(menubar, tearoff=0)
filemenu.add_command(label="Шинэчлэх", command=refresh)
menubar.add_cascade(label="Хэрэглэгдэхүүн", menu=filemenu) 
root.config(menu=menubar)


# Mainloop
check_status()
root.mainloop()