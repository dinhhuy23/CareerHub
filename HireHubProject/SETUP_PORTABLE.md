# Portable Setup Guide

## Requirements
- JDK 17
- Tomcat 10.1.x
- SQL Server with the project schema

## First-time setup on a new machine
1. Open the project in NetBeans.
2. Set project server to Tomcat 10.1.x (Project Properties -> Run -> Server).
3. Clean and Build.
4. Update DB connection values in `src/java/dal/DBContext.java`.

## File upload path behavior
- CV uploads are now portable by default.
- Priority:
  1. JVM arg `-Dhirehub.upload.dir=<absolute-path>`
  2. `${catalina.base}/hirehub_uploads/cv_files`
  3. `${user.home}/hirehub_uploads/cv_files`

## Notes
- `nbproject/private/` is machine-specific and should not be shared.
- `build/` and `dist/` are generated outputs and should not be shared.
