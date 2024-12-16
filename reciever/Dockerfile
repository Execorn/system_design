# --- Stage 1: Builder (Optional for simple python scripts but recommended for most use cases) ---
FROM python:3.11-slim AS builder 

# # Set working directory
# WORKDIR /app

# # Copy requirements file if exists
# #COPY requirements.txt .

# # Install dependencies if they exist
# RUN if [ -f "requirements.txt" ]; then \
#     pip install --no-cache-dir -r requirements.txt; \
#     fi

# COPY . .

# FROM python:3.11-slim AS final

# # Set working directory in run stage
# WORKDIR /app

# # Copy artifacts from builder stage
# COPY --from=builder /app /app

# # Add a non-root user (for security)
# RUN groupadd -r appuser && useradd -r -g appuser appuser
# # Set the user
# USER appuser

# Set CMD to the python script
CMD ["python", "reciever.py"]