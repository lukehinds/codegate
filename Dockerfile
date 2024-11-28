# Builder stage: Install dependencies and build the application
FROM python:3.12-slim AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable to ensure Python modules are installed in the correct location
ENV PYTHONPATH=/app

# Install Poetry
RUN pip install poetry==1.8.4

# Create a non-root user and switch to it
RUN adduser --system --no-create-home codegate --uid 1000

# Set the working directory
WORKDIR /app

# Copy only the files needed for installing dependencies
COPY pyproject.toml poetry.lock* /app/

# Configure Poetry and install dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --no-dev

# Copy the rest of the application
COPY . /app

# Runtime stage: Create the final lightweight image
FROM python:3.12-slim AS runtime

# Install runtime system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and switch to it
RUN adduser --system --no-create-home codegate --uid 1000
USER codegate

# Copy necessary artifacts from the builder stage
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /app /app

# Set the working directory
WORKDIR /app

# Set the PYTHONPATH environment variable
ENV PYTHONPATH=/app/src

# Allow to expose weaviate_data volume
VOLUME ["/app/weaviate_data"]

# Set the container's default entrypoint
EXPOSE 8989
#ENTRYPOINT ["python", "-m", "src.codegate.cli", "serve", "--port", "8989", "--host", "0.0.0.0"]
CMD ["python", "-m", "src.codegate.cli", "serve", "--port", "8989", "--host", "0.0.0.0"]