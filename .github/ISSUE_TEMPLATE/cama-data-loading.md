---
name: CAMA Data loading
about: Uploading CAMA from MINIO
title: "[cama]"
labels: 'data: ingestion'
assignees: ''

---

This will kick off the following data-loading procedure:
+ Use ssh to get CAMA from GINGER
+ Apply data cleaning to CAMA
+ Dump cleaned data into a temporary postgres database
+ Export from temporary database to a temporary DigitalOcean key
+ Use data-library action to move from temporary DigitalOcean URL to data-library directory structure, and trasform to a pgdump
+ Pull the pgdump into the build engine