#!/bin/bash

# Run create_password.py
python src/create_password.py

# # Run Terraform:
cd terraform && terraform init && terraform plan && terraform apply -auto-approve


# Run setup_scehma.py
cd .. && python src/setup_schema.py