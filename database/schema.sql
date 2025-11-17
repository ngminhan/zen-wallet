-- ============================
-- ENUM TYPES
-- ============================

CREATE TYPE transaction_category AS ENUM (
    'ESSENTIAL',
    'NON_ESSENTIAL',
    'SPIRITUAL',
    'UNEXPECTED'
);

CREATE TYPE transaction_type AS ENUM (
    'INCOME',
    'EXPENSE'
);

-- ============================
-- USERS TABLE
-- ============================

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    photo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================
-- GOALS TABLE
-- ============================

CREATE TABLE goals (
    goal_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    year INTEGER NOT NULL,
    month INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
    amount NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (user_id, year, month)
);

-- ============================
-- JOURNALS TABLE
-- ============================

CREATE TABLE journals (
    journal_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    date DATE NOT NULL UNIQUE,
    rate INTEGER CHECK (rate BETWEEN 1 AND 5),
    quote TEXT,
    question TEXT,
    answer TEXT,
    note TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================
-- TRANSACTIONS TABLE
-- ============================

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category transaction_category,
    amount NUMERIC(12,2) NOT NULL,
    note TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    type transaction_type NOT NULL DEFAULT 'EXPENSE',
    CONSTRAINT category_only_for_expense CHECK (
        (type = 'INCOME' AND category IS NULL) OR
        (type = 'EXPENSE' AND category IS NOT NULL)
    )
);

-- ============================
-- INDEXES (optional but recommended)
-- ============================

CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_date ON transactions(created_at);
