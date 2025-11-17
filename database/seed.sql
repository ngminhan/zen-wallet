-- =======================================
-- RESET ALL TABLES
-- =======================================
TRUNCATE TABLE transactions RESTART IDENTITY CASCADE;
TRUNCATE TABLE goals RESTART IDENTITY CASCADE;
TRUNCATE TABLE journals RESTART IDENTITY CASCADE;
TRUNCATE TABLE users RESTART IDENTITY CASCADE;

-- =======================================
-- USER
-- =======================================
INSERT INTO users (name, email, password_hash)
VALUES ('Demo User', 'demo@zenwallet.com', '$2a$12$Z.g4RLkrGKFdRE6SQ8R/ieuSKkV8U.kuil6KT5jLp8rvQi85I1jCK'); -- password: demo1234

-- =======================================
-- GOALS (Nhiều tháng để demo Goals View)
-- =======================================
INSERT INTO goals (user_id, year, month, amount)
VALUES
(1, 2025, 10, 4000000),
(1, 2025, 11, 5000000),
(1, 2025, 12, 6000000),
(1, 2026, 1, 4500000);

-- =======================================
-- INCOME (2 lần/tháng)
-- =======================================
INSERT INTO transactions (user_id, category, amount, note, type, created_at)
VALUES
(1, NULL, 7000000, 'Monthly salary', 'INCOME', NOW() - INTERVAL '28 days'),
(1, NULL, 1200000, 'Freelance iOS', 'INCOME', NOW() - INTERVAL '12 days'),
(1, NULL, 7000000, 'Monthly salary', 'INCOME', NOW() - INTERVAL '2 days'),
(1, NULL, 1500000, 'Design work', 'INCOME', NOW() - INTERVAL '6 days');

-- =======================================
-- EXPENSES (30 DAYS)
-- Tạo dữ liệu đẹp cho line chart + pie chart
-- =======================================

-- ESSENTIAL
INSERT INTO transactions (user_id, category, amount, note, type, created_at)
VALUES
(1, 'ESSENTIAL', 30000, 'Breakfast', 'EXPENSE', NOW() - INTERVAL '1 days'),
(1, 'ESSENTIAL', 45000, 'Lunch', 'EXPENSE', NOW() - INTERVAL '1 days'),
(1, 'ESSENTIAL', 150000, 'Groceries', 'EXPENSE', NOW() - INTERVAL '2 days'),
(1, 'ESSENTIAL', 60000, 'Dinner', 'EXPENSE', NOW() - INTERVAL '3 days'),
(1, 'ESSENTIAL', 42000, 'Lunch', 'EXPENSE', NOW() - INTERVAL '4 days'),
(1, 'ESSENTIAL', 20000, 'Coffee', 'EXPENSE', NOW() - INTERVAL '6 days'),
(1, 'ESSENTIAL', 50000, 'Breakfast', 'EXPENSE', NOW() - INTERVAL '8 days'),
(1, 'ESSENTIAL', 65000, 'Dinner', 'EXPENSE', NOW() - INTERVAL '10 days'),
(1, 'ESSENTIAL', 32000, 'Lunch', 'EXPENSE', NOW() - INTERVAL '12 days'),
(1, 'ESSENTIAL', 180000, 'Market', 'EXPENSE', NOW() - INTERVAL '14 days'),
(1, 'ESSENTIAL', 55000, 'Breakfast', 'EXPENSE', NOW() - INTERVAL '16 days'),
(1, 'ESSENTIAL', 90000, 'Groceries', 'EXPENSE', NOW() - INTERVAL '18 days'),
(1, 'ESSENTIAL', 70000, 'Dinner', 'EXPENSE', NOW() - INTERVAL '20 days'),
(1, 'ESSENTIAL', 28000, 'Coffee', 'EXPENSE', NOW() - INTERVAL '22 days'),
(1, 'ESSENTIAL', 47000, 'Lunch', 'EXPENSE', NOW() - INTERVAL '24 days');

-- NON_ESSENTIAL
INSERT INTO transactions (user_id, category, amount, note, type, created_at)
VALUES
(1, 'NON_ESSENTIAL', 120000, 'Bubble tea', 'EXPENSE', NOW() - INTERVAL '3 days'),
(1, 'NON_ESSENTIAL', 350000, 'New shirt', 'EXPENSE', NOW() - INTERVAL '7 days'),
(1, 'NON_ESSENTIAL', 150000, 'Cinema', 'EXPENSE', NOW() - INTERVAL '9 days'),
(1, 'NON_ESSENTIAL', 220000, 'Shoes cleaning', 'EXPENSE', NOW() - INTERVAL '11 days'),
(1, 'NON_ESSENTIAL', 110000, 'Cafe with friends', 'EXPENSE', NOW() - INTERVAL '18 days'),
(1, 'NON_ESSENTIAL', 170000, 'Delivery food', 'EXPENSE', NOW() - INTERVAL '27 days');

-- SPIRITUAL
INSERT INTO transactions (user_id, category, amount, note, type, created_at)
VALUES
(1, 'SPIRITUAL', 50000, 'Temple donation', 'EXPENSE', NOW() - INTERVAL '5 days'),
(1, 'SPIRITUAL', 60000, 'Charity', 'EXPENSE', NOW() - INTERVAL '15 days'),
(1, 'SPIRITUAL', 80000, 'Blessing ceremony', 'EXPENSE', NOW() - INTERVAL '29 days');

-- UNEXPECTED
INSERT INTO transactions (user_id, category, amount, note, type, created_at)
VALUES
(1, 'UNEXPECTED', 350000, 'Phone repair', 'EXPENSE', NOW() - INTERVAL '4 days'),
(1, 'UNEXPECTED', 200000, 'Medicine', 'EXPENSE', NOW() - INTERVAL '13 days'),
(1, 'UNEXPECTED', 500000, 'Motorbike repair', 'EXPENSE', NOW() - INTERVAL '21 days');
