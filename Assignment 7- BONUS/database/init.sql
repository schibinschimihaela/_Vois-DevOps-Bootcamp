CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tasks (title) VALUES 
    ('Setup Kubernetes cluster'),
    ('Deploy application'),
    ('Configure monitoring');

CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);