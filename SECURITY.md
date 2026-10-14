# Security policy

## Supported version

Security fixes are applied to the `main` branch. This repository contains pgRouting SQL patterns and a local demo; it is not a hosted service.

## Reporting a vulnerability

Email **zqmcomputing@gmail.com** with the subject `pgrouting-patterns security` if you find a vulnerability in the example code or workflow configuration. Please do not open a public issue for a sensitive report.

Include the affected file, the impact you observed, and reproduction steps when available.

## Local demo authentication

If the demo uses PostgreSQL trust authentication inside a disposable container, that container is for local experimentation only. Do not expose its port, reuse the configuration for a shared or production database, or load real road-network data with licensing restrictions into the demo.
