# Hevar Kochar — Cloud & DevOps Portfolio

Live portfolio: **https://hevar.cloud**

A professional static portfolio demonstrating AWS delivery, CI/CD, infrastructure practice, and serverless fundamentals.

## What this site demonstrates

- **Static delivery:** Amazon S3 origin served through Amazon CloudFront
- **Security:** S3 public access blocked; CloudFront Origin Access Control protects the bucket
- **Domain:** Route 53 / CloudFront custom domain for `hevar.cloud`
- **CI/CD:** GitHub Actions syncs the repository to S3 and invalidates CloudFront on every push to `main`
- **Serverless backend:** API Gateway + Lambda + DynamoDB visitor counter
- **Client deployment proof:** Dr. Dilshad ECB site at `https://www.drdilshadecb.com/` with source at `https://github.com/hevarrwandzi/hama-engineering`
- **IaC practice:** Terraform files for cloud infrastructure learning and repeatable setup

## Project structure

```text
.
├── .github/workflows/deploy.yml   # GitHub Actions deployment workflow
├── terraform/
│   ├── main.tf                    # Static-site infrastructure practice
│   └── monitoring.tf              # Monitoring / operational practice
├── index.html                     # Portfolio frontend
├── image.webp                     # Optimized visual asset
└── README.md
```

## Deployment flow

1. Push to `main`
2. GitHub Actions configures AWS credentials from repository secrets
3. Workflow syncs repository files to the S3 bucket
4. Workflow creates a CloudFront invalidation
5. Production is verified at `https://hevar.cloud`

## Maintainer

Hevar Kochar — CS student at Gasha Institute, freelance IT/web/DevOps builder based in Erbil, Kurdistan.


## Added portfolio proof

- **RS Collection production shop:** Docker Compose deployment on AWS EC2 with Caddy automatic HTTPS, PostgreSQL, health checks, and GitHub Actions CI. Live: `https://rscollection.online/`; source: `https://github.com/hevarrwandzi/rscollection`
