from flask import Flask, send_from_directory
from celery import Celery

app = Flask(__name__, static_folder='static')

# Configuration for Celery
app.config['CELERY_BROKER_URL'] = 'redis://localhost:6379/0'
app.config['CELERY_RESULT_BACKEND'] = 'redis://localhost:6379/0'

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)

#Celery Task for Calculate Distance
@celery.task
def calculate_distance(x, y):
    return x + y

#Celery Task for memory leak
@celery.task
def memory_leak_task():
    memory_leak_list = []
    while True:
        memory_leak_list.append('leak')
        time.sleep(0.1)

@app.route('/', defaults={'path': 'index.html'})

@app.route('/<path:path>')
def custom_static(path):
    return send_from_directory('static', path)

@app.route('/healthz')
def health_check():
    return 'Healthy', 200

@app.route('/ready')
def readiness_check():
    return 'Ready', 200


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
