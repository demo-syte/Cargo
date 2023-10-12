from flask import Flask
from celery import Celery

app = Flask(__name__)

# Configuration for Celery
app.config['CELERY_BROKER_URL'] = 'redis://localhost:6379/0'
app.config['CELERY_RESULT_BACKEND'] = 'redis://localhost:6379/0'

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)

@celery.task
def calculate_distance(x, y):
    return x + y

@celery.task
def memory_leak_task():
    memory_leak_list = []
    while True:
        memory_leak_list.append('leak')
        time.sleep(0.1)

@app.route('/')
def index():
    return "Celery App"

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
