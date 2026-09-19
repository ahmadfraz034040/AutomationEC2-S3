🚀 Automating EC2 + S3 Setup with IAM via AWS CLI
A real-world DevOps automation project — provisioning secure, self-managing AWS infrastructure entirely through Bash + AWS CLI, following Infrastructure-as-Code principles.
�
�
�
�
�
Load image
Load image
Load image
Load image
Load image
🎯 Industry Scenario
You are a DevOps Engineer at a SaaS company. You've been tasked with automating the provisioning of an EC2 instance that should:
✅ Be able to read from an S3 bucket
✅ Auto-stop and auto-start based on business logic
✅ Be provisioned entirely using AWS CLI + Bash scripting, ensuring repeatability and IaC principles
This project solves that problem end-to-end — no manual console clicks, no ClickOps. Everything is scripted, version-controlled, and repeatable.

┌─────────────────────┐        IAM Role         ┌──────────────────┐
│   EC2 Instance       │◄────────────────────────│   IAM Policy      │
│   (Bash-provisioned) │      (Read Access)       │   (S3 Read-Only)  │
└──────────┬───────────┘                          └──────────────────┘
           │
           │ Auto-start / Auto-stop
           ▼
┌─────────────────────┐
│   CloudWatch / Cron   │
│   Trigger Logic       │
└──────────┬───────────┘
           │
           ▼
┌─────────────────────┐
│   S3 Bucket           │
│   (Application Data)  │
└─────────────────────┘

⚙️ Setup & Usage
1. Clone the repository

git clone https://github.com/<your-username>/ec2-s3-iam-automation.git
cd ec2-s3-iam-automation 
Bash
2. Configure your AWS CLI
Bash
aws configure
3. Provision the S3 bucket
Bash
bash scripts/01-create-s3-bucket.sh
4. Create the IAM role and policy
Bash
bash scripts/02-create-iam-role.sh
5. Launch the EC2 instance
Bash
bash scripts/03-launch-ec2.sh
6. Enable auto-start / auto-stop
Bash
bash scripts/04-auto-start-stop.sh
7. Tear down when finished
Bash
bash scripts/teardown.sh

🔐 IAM Policy (S3 Read-Only)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}

This follows the principle of least privilege — the EC2 instance can only read from the designated bucket, nothing more.

⏰ Auto-Start / Auto-Stop Logic
Business logic example: keep the instance running only during work hours (9 AM–7 PM, weekdays) to minimize cost.
#!/bin/bash
INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"
HOUR=$(date +%H)
DAY=$(date +%u)  # 1 = Monday ... 7 = Sunday

if [[ "$DAY" -le 5 && "$HOUR" -ge 9 && "$HOUR" -lt 19 ]]; then
  aws ec2 start-instances --instance-ids "$INSTANCE_ID"
else
  aws ec2 stop-instances --instance-ids "$INSTANCE_ID"
fi

Schedule it with cron or migrate to an EventBridge + Lambda trigger for a fully serverless, production-grade setup.
💡 Why This Matters (DevOps Value)
Repeatability — Any engineer can reproduce this exact environment from scratch
Cost Optimization — Auto-stop/start reduces idle EC2 spend
Security — No hardcoded AWS keys; access is scoped via IAM roles
Infrastructure as Code — Version-controlled, auditable, and easy to extend to Terraform/CloudFormation later
🧭 Next Steps / Extensions
[ ] Migrate scripts to Terraform for state management
[ ] Replace cron with EventBridge + Lambda for serverless scheduling
[ ] Add CloudWatch alarms for cost and usage monitoring
[ ] Integrate with a CI/CD pipeline (GitHub Actions) for automated deployment
📄 License

This project is licensed under the MIT License.
🙌 Author
Built as part of a hands-on DevOps automation learning journey — mastering AWS CLI, Bash scripting, and IAM to solve real-world infrastructure challenges.
⭐ If this project helped you, consider giving it a star!