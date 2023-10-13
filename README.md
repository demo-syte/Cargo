# Cargo
My Devops Task
Python-based stack employs the Celery distributed task queue for asynchronous processing.

### 1. **Project Setup**

#### Terraform:
I've set up modules based on Terraform.

**Directory Structure**:

#### Terrform

```
terraform/
│
├── modules/
│   ├── vpc/
│   ├── eks/
│   
│
├── environments/
│   ├── dev/
│   └── prod/
│
└── main.tf
```

- `modules/`: Here, I store reusable components.
- `environments/`: This contains my Dev & Prod environment configurations.

#### Application & Helm:

```
helm-chart/
│
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── hpa.yaml
│
├── values.yaml
└── Chart.yaml
```

### 2. **Python Application with Celery**

I chose FastAPI for its simplicity. I've implemented both tasks: `calculate_distance` and `memory_leak_task`.

```python
from fastapi import FastAPI
from some_celery_module import celery_app

app = FastAPI()

@app.post("/distance/")
def calculate(x: int, y: int):
    task = celery_app.send_task("calculate_distance", args=[x, y])
    return {"task_id": task.id}

@app.post("/memory-leak/")
def memory_leak():
    task = celery_app.send_task("memory_leak_task")
    return {"task_id": task.id}
```

### 3. **Health Check Mechanism**

#### Liveness & Readiness Probes:

In my `deployment.yaml` (within Helm charts), I've set up liveness & readiness probes for Celery:

```yaml
livenessProbe:
  exec:
    command:
    - celery
    - inspect
    - ping
  initialDelaySeconds: 30
  timeoutSeconds: 5

readinessProbe:
  exec:
    command:
    - celery
    - inspect
    - ping
  initialDelaySeconds: 5
  timeoutSeconds: 5
```

These probes help me ensure Celery workers are responsive. If they aren't, Kubernetes restarts the pod for me.

#### Monitoring and Alerts:

I've deployed Prometheus & Grafana using their Helm charts. I monitor the Celery metrics. I've employed the `celery-exporter` to retrieve metrics from Celery for Prometheus.

When anomalies arise:

1. Prometheus alerts based on my set criteria (like a sudden increase in task failures or memory consumption).
2. Prometheus sends these alerts to the Alertmanager.
3. I've configured Alertmanager to take actions, like sending notifications.

### 4. **Auto-Scaling based on Load**

In situations where tasks might accumulate, I've employed the Kubernetes Horizontal Pod Autoscaler (HPA) to adjust the number of worker pods, depending on the tasks queued.

```yaml
# hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: celery-worker-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: celery-worker-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: External
    external:
      metricName: celery_queue_length
      targetValue: 10
```

### 5. **Periodic Health Check Job**

I've arranged for a Kubernetes CronJob to periodically (like every 5 minutes) run a job. This job pushes a Celery task and monitors its status. If the task fails or doesn't finish as expected, the job can either raise an alert or directly engage with the Kubernetes API to restart any problematic pods.

### Conclusion:

My combination of application-level health checks (liveness/readiness probes), monitoring/alerts via Prometheus, and auto-scaling ensures that our asynchronous tasks are managed promptly and efficiently for the Celery application within our EKS cluster.

### Sample Architecture

Here is the sample underline Three-Tier architecture of Celery App
![Setup](https://user-images.githubusercontent.com/78690371/140008582-4a4bb976-fff1-47c7-974d-563b5e58c3d3.png)

### Disaster Plan for Celery App
<img src="https://github.com/demo-syte/Cargo/assets/78690371/61a6da10-35d3-42bd-941e-7a5a5eed9b06" width="400"/>

