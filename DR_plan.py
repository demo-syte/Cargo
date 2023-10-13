#python script for generating the DR plan for Celery Application.

import diagrams
print(dir(diagrams))

from diagrams import Diagram, Cluster
from diagrams.aws.compute import EKS
from diagrams.aws.database import RDS
from diagrams.aws.network import Route53
from diagrams.aws.storage import S3

with Diagram("Disaster Recovery Plan for Celery App", show=False):
    with Cluster("Tokyo"):
        tokyo = EKS("AWS Datacenter in Tokyo")
        cross_region_replication = EKS("Cross-Region Replication")
        multi_az = EKS("Multi-AZ Deployment")
        automated_backups = RDS("Automated Backups")
        dr_plan = EKS("Disaster Recovery Plan")
        ami = EKS("AMI and Snapshot Replication")
        dns_failover = Route53("DNS Failover")

        tokyo >> cross_region_replication
        tokyo >> multi_az
        tokyo >> automated_backups
        tokyo >> dr_plan
        tokyo >> ami
        tokyo >> dns_failover

    with Cluster("Singapore"):
        singapore = EKS("AWS Datacenter in Singapore")
        cross_region_replication >> singapore
        multi_az >> singapore
        automated_backups >> singapore
        ami >> singapore
        dns_failover >> singapore

    with Cluster("Celery-APP"):
        celery_app = EKS("Celery Application")
        celery_app >> multi_az

    with Cluster("To`kyo"):
      testing = EKS("EKS Cluster")
      dr_plan >> testing
	
