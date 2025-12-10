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
-- GOALS 
-- =======================================
DO $$
DECLARE 
    current_year  INT := EXTRACT(YEAR FROM NOW());
    current_month INT := EXTRACT(MONTH FROM NOW());
    i INT;
BEGIN
    FOR i IN 0..3 LOOP  
        INSERT INTO goals (user_id, year, month, amount)
        VALUES
        (1,
         EXTRACT(YEAR FROM (NOW() - (i || ' months')::interval)),
         EXTRACT(MONTH FROM (NOW() - (i || ' months')::interval)),
         4000000 + (i * 300000)  
        );
    END LOOP;
END $$;

-- =======================================
-- INCOME 
-- =======================================
INSERT INTO transactions (user_id, category, amount, note, type, created_at)
VALUES
(1, NULL, 7000000,'Salary','INCOME'::transaction_type,NOW()),
(1, NULL, 2000000,'Freelance UI','INCOME'::transaction_type,NOW() - INTERVAL '5 days'),
(1, NULL, 1500000,'Part-time lecture','INCOME'::transaction_type,NOW() - INTERVAL '9 days'),
(1, NULL, 2500000,'Mobile app fix','INCOME'::transaction_type,NOW() - INTERVAL '14 days'),
(1, NULL, 500000,'Task micro gig','INCOME'::transaction_type,NOW() - INTERVAL '20 days'),
(1, NULL, 7500000,'Salary','INCOME'::transaction_type,NOW() - INTERVAL '27 days'),
(1, NULL, 1800000,'Freelance website','INCOME'::transaction_type,NOW() - INTERVAL '30 days');

-- =======================================
-- EXPENSES 
-- =======================================

DO $$
DECLARE i INT;
BEGIN
	FOR i IN 0..30 LOOP

		-- ESSENTIAL
		INSERT INTO transactions (user_id, category, amount, note, type, created_at)
		VALUES (1,'ESSENTIAL'::transaction_category,30000+(i*500),'Breakfast','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);

		INSERT INTO transactions (user_id, category, amount, note, type, created_at)
		VALUES (1,'ESSENTIAL'::transaction_category,45000+(i*300),'Lunch','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);

		INSERT INTO transactions (user_id, category, amount, note, type, created_at)
		VALUES (1,'ESSENTIAL'::transaction_category,50000+(i*200),'Groceries','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);

		-- NON ESSENTIAL
		IF i % 2 = 0 THEN
			INSERT INTO transactions (user_id, category, amount, note, type, created_at)
			VALUES (1,'NON_ESSENTIAL'::transaction_category,90000+(i*450),'Boba/movie','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);
		END IF;
		IF i % 3 = 0 THEN
			INSERT INTO transactions (user_id, category, amount, note, type, created_at)
			VALUES (1,'NON_ESSENTIAL'::transaction_category,150000+(i*600),'Shopping/cafe','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);
		END IF;

		-- SPIRITUAL
		IF i % 5 = 0 THEN
			INSERT INTO transactions (user_id, category, amount, note, type, created_at)
			VALUES (1,'SPIRITUAL'::transaction_category,300000+(i*200),'Donation','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);
		END IF;

		-- UNEXPECTED
		IF i % 7 = 0 THEN
			INSERT INTO transactions (user_id, category, amount, note, type, created_at)
			VALUES (1,'UNEXPECTED'::transaction_category,150000+(i*5000),'Repair','EXPENSE'::transaction_type,NOW()-(i||' days')::interval);
		END IF;

	END LOOP;
END $$;
-- =======================================
