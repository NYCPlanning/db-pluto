---
name: PTS data loading
about: Use this issue to trigger a PTS ETL from MINIO
title: "[pts] dataloading"
labels: 'data: ingestion'
assignees: ''

---

This will kick off the following data-loading procedure:
+ Use ssh to get PTS from GINGER
+ Apply data cleaning to PTS
+ Dump cleaned data into a temporary postgres database
+ Export from temporary database to a temporary DigitalOcean key
+ Use data-library action to move from temporary DigitalOcean URL to data-library directory structure, and trasform to a pgdump
