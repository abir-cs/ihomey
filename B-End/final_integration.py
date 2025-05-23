# This is the code (python) integrated in Raspberry Pi 4 To communicate with the app :
import paho.mqtt.client as mqtt
import RPi.GPIO as GPIO
import json
import threading
from datetime import datetime, timedelta
import time
import adafruit_dht
import board

# ================= GPIO SETUP =================
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

# Pins
LED_PIN = 23
TRIG = 27
ECHO = 24
DHT_PIN = board.D22

GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.setup(TRIG, GPIO.OUT)
GPIO.setup(ECHO, GPIO.IN)

pwm = GPIO.PWM(LED_PIN, 1000)
pwm.start(0)

dht_device = adafruit_dht.DHT11(DHT_PIN)

# ================= MQTT CONFIG =================
#  broker = "test.mosquitto.org"
broker = "localhost"
port = 1883

topics = [
    ("light/control", 0),
    ("light/opacity", 0),
    ("light/schedule", 0),
    ("light/auto_mode", 0)
]

topic_temp = "sensor/temperature"
topic_humidity = "sensor/humidity"

client = mqtt.Client()

# ================= STATE VARIABLES =================
current_opacity = 100
led_is_on = False
auto_mode = True
auto_light_timeout = 10
last_motion_time = None

# ================= PWM CONTROL =================
def apply_pwm():
    pwm.ChangeDutyCycle(current_opacity if led_is_on else 0)

def turn_on():
    global led_is_on
    led_is_on = True
    print("Turning light ON")
    apply_pwm()

def turn_off():
    global led_is_on
    led_is_on = False
    print("Turning light OFF")
    apply_pwm()

def schedule_light(from_time_str, to_time_str):
    now = datetime.now()
    try:
        # Detect format and parse time
        if 'AM' in from_time_str.upper() or 'PM' in from_time_str.upper():
            from_time = datetime.strptime(from_time_str, "%I:%M %p")
            to_time = datetime.strptime(to_time_str, "%I:%M %p")
        else:
            from_time = datetime.strptime(from_time_str, "%H:%M")
            to_time = datetime.strptime(to_time_str, "%H:%M")

        from_dt = now.replace(hour=from_time.hour, minute=from_time.minute, second=0, microsecond=0)
        to_dt = now.replace(hour=to_time.hour, minute=to_time.minute, second=0, microsecond=0)

        if from_dt < now:
            from_dt += timedelta(days=1)
        if to_dt < now:
            to_dt += timedelta(days=1)

        delay_on = (from_dt - now).total_seconds()
        delay_off = (to_dt - now).total_seconds()

        print(f"Scheduling ON in {delay_on:.0f}s and OFF in {delay_off:.0f}s")
        threading.Timer(delay_on, turn_on).start()
        threading.Timer(delay_off, turn_off).start()

    except Exception as e:
        print("Schedule error:", e)

# ================= DISTANCE SENSOR LOOP =================
def distance_loop():
    global last_motion_time, led_is_on, auto_mode
    try:
        while True:
            if not auto_mode:
                time.sleep(1)
                continue

            GPIO.output(TRIG, False)
            time.sleep(0.05)
            GPIO.output(TRIG, True)
            time.sleep(0.00001)
            GPIO.output(TRIG, False)

            while GPIO.input(ECHO) == 0:
                pulse_start = time.time()
            while GPIO.input(ECHO) == 1:
                pulse_end = time.time()

            pulse_duration = pulse_end - pulse_start
            distance = round(pulse_duration * 17150, 2)
            print(f"Distance: {distance} cm")

            if 2 < distance < 10:
                print("Presence detected ✅")
                last_motion_time = time.time()
                if not led_is_on:
                    turn_on()
            elif led_is_on and last_motion_time:
                if time.time() - last_motion_time > auto_light_timeout:
                    print("No presence ❌ - Timeout reached")
                    turn_off()

            time.sleep(0.5)
    except Exception as e:
        print("Distance loop error:", e)

# ================= TEMP & HUMIDITY LOOP =================
def dht_loop():
    try:
        while True:
            try:
                temperature = dht_device.temperature
                humidity = dht_device.humidity
                if temperature is not None and humidity is not None:
                    print(f"Temp={temperature:.1f}°C  Humidity={humidity:.1f}%")
                    client.publish(topic_temp, f"{temperature:.1f}")
                    client.publish(topic_humidity, f"{humidity:.1f}")
                else:
                    print("Sensor returned None")
            except RuntimeError as e:
                print("DHT error:", e)
            time.sleep(2)
    except Exception as e:
        print("DHT loop stopped:", e)

# ================= MQTT CALLBACKS =================
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker")
        client.subscribe(topics)
    else:
        print("Connection failed. Code:", rc)

def on_message(client, userdata, msg):
    global current_opacity, auto_mode
    topic = msg.topic
    payload = msg.payload.decode()
    print(f"[{topic}] Message: {payload}")

    if topic == "light/control":
        if payload.upper() == "ON":
            turn_on()
        elif payload.upper() == "OFF":
            turn_off()

    elif topic == "light/opacity":
        try:
            value = int(payload)
            if 0 <= value <= 100:
                current_opacity = value
                apply_pwm()
                print(f"Opacity set to {value}%")
            else:
                print("Opacity must be 0-100")
        except ValueError:
            print("Invalid opacity value")

    elif topic == "light/schedule":
        try:
            data = json.loads(payload)
            from_time = data.get("from")
            to_time = data.get("to")
            if from_time and to_time:
                schedule_light(from_time, to_time)
            else:
                print("Schedule missing 'from' or 'to'")
        except Exception as e:
            print("Error parsing schedule:", e)

    elif topic == "light/auto_mode":
        if payload.lower() == "on":
            auto_mode = True
            print("Auto mode enabled.")
        elif payload.lower() == "off":
            auto_mode = False
            print("Auto mode disabled.")

# ================= MAIN =================
client.on_connect = on_connect
client.on_message = on_message
client.connect(broker, port, 60)

try:
    threading.Thread(target=distance_loop, daemon=True).start()
    threading.Thread(target=dht_loop, daemon=True).start()
    client.loop_forever()
except KeyboardInterrupt:
    print("Shutting down...")
finally:
    pwm.stop()
    GPIO.cleanup()
    client.disconnect()
