#Требуется: pip install pyserial

import queue
import threading
import time
import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox

import serial
import serial.tools.list_ports

# --- Константы по лекции ---
BAUD = 9600
MIN_ANGLE = 20            # совпадает с minAngle в скетче
MAX_ANGLE = 160           # совпадает с maxAngle в скетче
READ_TIMEOUT = 2          # тайм-аут чтения, сек
WRITE_TIMEOUT = 2         # тайм-аут записи, сек
DEBOUNCE_MS = 150         # задержка отправки при перетаскивании слайдера


class ServoApp:
    def __init__(self, root: tk.Tk):
        self.root = root
        root.title("Сервопривод Arduino — управление из Python")
        root.geometry("780x700")
        root.minsize(680, 560)

        # --- Состояние ---
        self.ser: serial.Serial | None = None
        self.running = False
        self.sender_thread: threading.Thread | None = None
        self.send_queue: queue.Queue = queue.Queue()
        self.gui_queue: queue.Queue = queue.Queue()
        self.last_sent: int | None = None
        self._pending = None
        self._suppress_slider = False
        self._closing = False

        self._build_ui()
        self.refresh_ports()
        self.root.after(100, self._process_queue)
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)

    # ================== ИНТЕРФЕЙС ==================

    def _build_ui(self):
        pad = dict(padx=8, pady=4)

        # ---------- Подключение ----------
        conn = ttk.LabelFrame(self.root, text="Подключение к Arduino")
        conn.pack(fill="x", **pad)

        ttk.Label(conn, text="COM-порт:").grid(row=0, column=0, padx=6, pady=8)
        self.port_combo = ttk.Combobox(conn, width=20, state="readonly")
        self.port_combo.grid(row=0, column=1, padx=6, pady=8)

        ttk.Button(conn, text="Обновить", command=self.refresh_ports) \
            .grid(row=0, column=2, padx=6, pady=8)

        self.btn_connect = ttk.Button(conn, text="Подключить", width=14,
                                      command=self.toggle_connection)
        self.btn_connect.grid(row=0, column=3, padx=6, pady=8)

        self.status_label = tk.Label(conn, text="● Отключено", fg="#c0392b",
                                     font=("Segoe UI", 10, "bold"))
        self.status_label.grid(row=0, column=4, padx=12, pady=8)
        conn.columnconfigure(5, weight=1)

        # ---------- Управление ----------
        servo = ttk.LabelFrame(self.root,
                               text=f"Управление сервоприводом ({MIN_ANGLE}°–{MAX_ANGLE}°)")
        servo.pack(fill="x", **pad)

        self.angle_text = tk.StringVar(value="90°")
        tk.Label(servo, textvariable=self.angle_text, fg="#2c3e50",
                 font=("Segoe UI", 26, "bold")).pack(pady=(10, 0))

        self.scale = tk.Scale(servo, from_=MIN_ANGLE, to=MAX_ANGLE,
                              orient="horizontal", resolution=1,
                              showvalue=False, length=560,
                              troughcolor="#dfe6e9")
        self.scale.set(90)
        self.scale.configure(command=self.on_slider)
        self.scale.pack(pady=8, padx=12)

        row = ttk.Frame(servo)
        row.pack(pady=(0, 12))
        self.quick_buttons = []
        for a in (20, 60, 90, 120, 160):
            b = ttk.Button(row, text=f"{a}°", width=7,
                           command=lambda a=a: self.quick_angle(a))
            b.pack(side="left", padx=4)
            self.quick_buttons.append(b)

        # ---------- Логи ----------
        logf = ttk.LabelFrame(self.root, text="Терминал логов")
        logf.pack(fill="both", expand=True, **pad)

        self.log_widget = scrolledtext.ScrolledText(logf, height=14,
                                                    state="disabled",
                                                    font=("Consolas", 9),
                                                    wrap="word")
        self.log_widget.pack(fill="both", expand=True, padx=6, pady=6)
        self.log_widget.tag_config("info", foreground="#7f8c8d")
        self.log_widget.tag_config("send", foreground="#2980b9")
        self.log_widget.tag_config("recv", foreground="#2c3e50")
        self.log_widget.tag_config("ok",   foreground="#27ae60")
        self.log_widget.tag_config("err",  foreground="#c0392b")

        self._set_controls_enabled(False)

    # ================== ЛОГИ ==================

    def log(self, msg: str, tag: str = "info"):
        ts = time.strftime("%H:%M:%S")
        self.log_widget.configure(state="normal")
        self.log_widget.insert("end", f"[{ts}] {msg}\n", tag)
        self.log_widget.see("end")
        self.log_widget.configure(state="disabled")

    def queue_log(self, text: str, tag: str = "info"):
        self.gui_queue.put(("log", tag, text))

    def queue_call(self, fn):
        self.gui_queue.put(("call", fn))

    def _process_queue(self):
        try:
            while True:
                item = self.gui_queue.get_nowait()
                if item[0] == "log":
                    self.log(item[2], item[1])
                elif item[0] == "call":
                    item[1]()
        except queue.Empty:
            pass
        self.root.after(100, self._process_queue)

    # ================== ПОРТЫ ==================

    def refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        self.port_combo["values"] = ports
        if ports:
            if self.port_combo.get() not in ports:
                self.port_combo.set(ports[0])
            self.log(f"Найдены порты: {', '.join(ports)}", "info")
        else:
            self.port_combo.set("")
            self.log("Последовательные порты не найдены", "err")

    # ================== ПОДКЛЮЧЕНИЕ ==================

    def _is_connected(self) -> bool:
        return self.ser is not None and self.ser.is_open

    def toggle_connection(self):
        if self._is_connected():
            self.disconnect()
        else:
            self.connect()

    def connect(self):
        port = self.port_combo.get().strip()
        if not port:
            messagebox.showwarning("Порт не выбран",
                                   "Выберите COM-порт из выпадающего списка.")
            return
        self.btn_connect.configure(state="disabled")
        self.status_label.configure(text="● Подключение...", fg="#f39c12")
        self.log(f"Открытие {port} ({BAUD} бод)...", "info")
        threading.Thread(target=self._do_connect, args=(port,),
                         daemon=True).start()

    def _do_connect(self, port: str):
        try:
            ser = serial.Serial(port, BAUD,
                                timeout=READ_TIMEOUT,
                                write_timeout=WRITE_TIMEOUT)
        except Exception as e:
            self.queue_call(lambda: self._connect_failed(str(e)))
            return

        # Uno перезапускается при открытии порта — по лекции ждём 2 с
        time.sleep(2.0)
        try:
            ser.reset_input_buffer()
        except Exception:
            pass

        if self._closing:
            try:
                ser.close()
            except Exception:
                pass
            return

        self.ser = ser
        self.running = True
        self.sender_thread = threading.Thread(target=self._sender_loop,
                                              daemon=True)
        self.sender_thread.start()
        self.queue_call(self._connect_ok)

    def _connect_ok(self):
        self.btn_connect.configure(state="normal", text="Отключить")
        self.status_label.configure(text="● Подключено", fg="#27ae60")
        self._set_controls_enabled(True)
        self.log(f"Соединение установлено ({self.ser.port})", "ok")

    def _connect_failed(self, err: str):
        self.ser = None
        self.running = False
        self.btn_connect.configure(state="normal", text="Подключить")
        self.status_label.configure(text="● Отключено", fg="#c0392b")
        self._set_controls_enabled(False)
        self.log(f"Ошибка порта: {err}", "err")

    def disconnect(self, lost: bool = False):
        self.running = False
        self.send_queue.put(None)  # разбудить поток-отправитель

        ser, self.ser = self.ser, None
        if ser is not None:
            try:
                ser.close()
            except Exception:
                pass

        if (self.sender_thread and self.sender_thread.is_alive()
                and self.sender_thread is not threading.current_thread()):
            self.sender_thread.join(timeout=READ_TIMEOUT + 0.5)
        self.sender_thread = None

        self.btn_connect.configure(state="normal", text="Подключить")
        self.status_label.configure(text="● Отключено", fg="#c0392b")
        self._set_controls_enabled(False)
        self.log("Соединение потеряно" if lost else "Отключено",
                 "err" if lost else "info")

    # ================== ПОТОК ОТПРАВКИ / ПРИЁМА ==================

    def _sender_loop(self):
        while self.running:
            try:
                angle = self.send_queue.get(timeout=0.2)
            except queue.Empty:
                continue
            if angle is None:
                return

            ser = self.ser
            if ser is None or not ser.is_open:
                self.queue_log("Порт закрыт — команда не отправлена", "err")
                continue

            try:
                ser.write(f"{angle}\n".encode("ascii"))
                self.queue_log(f"→ {angle}", "send")
                answer = ser.readline()
            except Exception as e:
                self.queue_log(f"Ошибка обмена: {e}", "err")
                self.queue_call(lambda: self.disconnect(lost=True))
                return

            # По лекции: если нет полного ответа (нет \n) — обмен нарушен
            if not answer.endswith(b"\n"):
                self.queue_log(
                    "Нет полного ответа (тайм-аут). Проверьте плату.", "err")
                self.queue_call(lambda: self.disconnect(lost=True))
                return

            response = answer.decode("ascii", errors="replace").strip()
            self.queue_log(f"← {response}", "recv")

            if response == f"OK {angle}":
                self.queue_log(
                    f"Arduino приняла команду: {angle}°", "ok")
            elif response == "ERR angle":
                self.queue_log(
                    f"Arduino отклонила команду: {response}", "err")
            else:
                self.queue_log(
                    f"Неожиданный ответ Arduino: {response}", "err")

    # ================== УПРАВЛЕНИЕ УГЛОМ ==================

    def on_slider(self, value):
        angle = int(round(float(value)))
        self.angle_text.set(f"{angle}°")
        if self._suppress_slider:
            return

        if self._pending is not None:
            self.root.after_cancel(self._pending)
        self._pending = self.root.after(
            DEBOUNCE_MS, lambda: self._send_from_slider(angle))

    def _send_from_slider(self, angle: int):
        self._pending = None
        if angle != self.last_sent:
            self._enqueue_send(angle)

    def quick_angle(self, angle: int):
        self._suppress_slider = True
        try:
            self.scale.set(angle)
        finally:
            self._suppress_slider = False
        self.angle_text.set(f"{angle}°")

        if self._pending is not None:
            self.root.after_cancel(self._pending)
            self._pending = None
        self._enqueue_send(angle)

    def _enqueue_send(self, angle: int):
        if not self._is_connected():
            self.log("Сервопривод не подключён — команда не отправлена", "err")
            return
        self.last_sent = angle
        self.send_queue.put(angle)

    # ================== ПРОЧЕЕ ==================

    def _set_controls_enabled(self, enabled: bool):
        state = "normal" if enabled else "disabled"
        self.scale.configure(state=state)
        for b in self.quick_buttons:
            b.configure(state=state)

    def on_close(self):
        self._closing = True
        self.running = False
        self.send_queue.put(None)

        ser, self.ser = self.ser, None
        if ser is not None:
            try:
                ser.close()
            except Exception:
                pass

        if (self.sender_thread and self.sender_thread.is_alive()
                and self.sender_thread is not threading.current_thread()):
            self.sender_thread.join(timeout=READ_TIMEOUT + 0.5)
        self.root.destroy()


if __name__ == "__main__":
    root = tk.Tk()
    try:
        ttk.Style().theme_use("clam")
    except tk.TclError:
        pass
    ServoApp(root)
    root.mainloop()