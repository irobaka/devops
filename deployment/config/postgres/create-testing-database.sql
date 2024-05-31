SELECT 'CREATE DATABASE devops_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'devops_test')\gexec
