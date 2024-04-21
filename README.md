# API-gateway
This project is designed to streamline the deployment and development process using Docker Compose for production environments and local running for development.

## Running the Project

### Docker Compose (Production Environment)

To run the project using Docker Compose for production environments, execute the following command:

```bash
COMPOSE_PROJECT_NAME=devops docker-compose up --build --force-recreate
```
### Local Running (Development)

Before running, set REGISTRY_SERVER=localhost in IntelliJ IDEA. Then, press the run button.
