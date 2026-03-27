# Hevar's Cloud Architecture Portfolio 🚀🏗️🥊

A cloud portfolio and DevOps lab for Hevar, built to demonstrate AWS fundamentals, infrastructure as code, and automated deployment workflows.

---

## 🌐 Live Project
**URL:** [https://hevar.cloud](https://hevar.cloud)  
**Region:** `eu-north-1` (Stockholm)

---

## 🏗️ The Architecture

This project shows a practical, production-style AWS setup focused on security, automation, and maintainability.

### 1. Frontend & Delivery 🌐
*   **Storage:** Amazon S3 (configured for static website hosting).
*   **CDN:** Amazon CloudFront (Global Content Delivery Network) provides HTTPS termination and edge caching.
*   **Security:** CloudFront **Origin Access Control (OAC)** locks down the S3 bucket—ensuring the files are *only* accessible through the CDN.
*   **SSL/TLS:** AWS Certificate Manager (ACM) manages the domain's security certificates.

### 2. Serverless Backend 🧠⚡
*   **Compute:** AWS Lambda (Python 3.12) handles dynamic visitor tracking.
*   **Database:** Amazon DynamoDB (NoSQL) stores persistent visitor metrics using **On-Demand Capacity** for optimal cost efficiency.
*   **API:** AWS API Gateway (REST) provides a secure, public-facing endpoint for the frontend to communicate with the backend.

### 3. Infrastructure as Code (IaC) 🏗️🛠️
*   **Tool:** HashiCorp **Terraform**.
*   **Benefit:** The entire AWS environment (S3, CloudFront, Route 53, Lambda, DynamoDB) is defined in code (`main.tf`, `backend.tf`). This allows for reproducible, version-controlled deployments.

### 4. CI/CD Pipeline ⚙️🚀
*   **Tool:** GitHub Actions.
*   **Workflow:** Every push to `main` triggers deployment steps that update the frontend in S3 and refresh the CloudFront cache.

---

## 🛠️ Technical Arsenal
*   **Cloud:** AWS (Certified Cloud Practitioner level + SAA in progress)
*   **DevOps:** CI/CD Pipelines, GitHub Actions, Terraform (IaC)
*   **Containers:** Docker
*   **Systems:** Linux Administration, Shell Scripting, Networking (CCNA study)
*   **Hardware:** RF Signal Analysis, Physical Systems Integration

---

## 📂 Project Structure
```text
.
├── .github/workflows/deploy.yml   # CI/CD Pipeline configuration
├── terraform/
│   ├── main.tf                    # Infrastructure definition (S3, CF, DNS)
│   └── backend.tf                 # Serverless resources (Lambda, DynamoDB, API)
├── index.html                     # Responsive Frontend
└── image.webp                     # Optimized visual assets
```

---

## 🥊 Developed with Attitude
This project is maintained with automation support from **Tifa**, Hevar's AI assistant.

*“I don't just use tools; I build infrastructures that work.”* — **Hevar**
