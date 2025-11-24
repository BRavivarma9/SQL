/* ============================================================
   SQL STRING FUNCTIONS PRACTICE (WITH CONCEPT EXPLANATIONS)
   Using: sakila.film and sakila.customer tables
   ============================================================ */

/* ============================================================
   1. RPAD & LPAD → Padding Strings
   ------------------------------------------------------------
   RPAD(text, total_length, pad_char)
     → Adds characters to the RIGHT side of text.

   LPAD(text, total_length, pad_char)
     → Adds characters to the LEFT side of text.

   Purpose:
   - Useful for formatting output into fixed widths.
   - Helps in aligning text while displaying results.
   ============================================================ */

/* RPAD Example */
SELECT title,
       RPAD(title, 20, '*') AS right_padded
FROM sakila.film
LIMIT 5;

/* LPAD + RPAD Combined Example */
SELECT title,
       LPAD(RPAD(title, 20, '*'), 25, '*') AS left_padded
FROM sakila.film
LIMIT 5;


/* ============================================================
   2. SUBSTRING → Extract part of a string
   ------------------------------------------------------------
   SUBSTRING(text, start_position, length)

   Purpose:
   - Used to extract a smaller portion from a big text.
   - Good for slicing text fields like names, titles, codes.
   ============================================================ */
SELECT title,
       SUBSTRING(title, 3, 9) AS short_title
FROM sakila.film;


/* ============================================================
   3. CONCAT → Combine strings together
   ------------------------------------------------------------
   CONCAT(str1, str2, ...)

   Purpose:
   - Join multiple text values into one.
   - Useful for creating full names, full addresses, etc.
   ============================================================ */
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM sakila.customer;


/* ============================================================
   4. REVERSE → Reverse the text
   ------------------------------------------------------------
   REVERSE(text)

   Purpose:
   - Reverses the order of characters in a string.
   - Mostly used in text manipulation or debugging.
   ============================================================ */
SELECT title,
       REVERSE(title) AS reversed_title
FROM sakila.film
LIMIT 5;


/* ============================================================
   5. LENGTH → Count the number of characters
   ------------------------------------------------------------
   LENGTH(text)

   Purpose:
   - Find how long a string is.
   - Used for validation (e.g., telephone length).
   - Used for filtering large or small text values.
   ============================================================ */
SELECT title,
       LENGTH(title) AS title_length
FROM sakila.film
WHERE LENGTH(title) > 15;   -- Filtering long titles


/* ============================================================
   6. LOCATE → Find the position of a character
      SUBSTRING → Extract from that position
   ------------------------------------------------------------
   LOCATE('char', text) → returns the index number where 'char' starts.
   SUBSTRING(text, index+1) → extract the remaining part.

   Purpose:
   - Very useful to extract domain names from email IDs.
   ============================================================ */
SELECT email,
       SUBSTRING(email, LOCATE('@', email) + 1) AS domain
FROM sakila.customer;


/* ============================================================
   7. SUBSTRING_INDEX → Extract part based on delimiter
   ------------------------------------------------------------
   SUBSTRING_INDEX(text, delimiter, count)
   - If count = -1 → returns everything after the delimiter.
   - If count = 1 → returns everything before the delimiter.

   Purpose:
   - Extract domain names or parts of a URL.
   ============================================================ */
SELECT email,
       SUBSTRING_INDEX(email, '@', -1) AS domain
FROM sakila.customer;


/* ============================================================
   8. UPPER & LOWER → Case conversion
   ------------------------------------------------------------
   UPPER(text) → convert to uppercase
   LOWER(text) → convert to lowercase

   Purpose:
   - Standardize data for comparison.
   - Case-insensitive searching.
   ============================================================ */
SELECT title,
       UPPER(title) AS upper_title,
       LOWER(title) AS lower_title
FROM sakila.film
WHERE UPPER(title) LIKE '%LOVELY%' OR
      UPPER(title) LIKE '%MAN%';


/* ============================================================
   9. LEFT & RIGHT → Extract characters from start or end
   ------------------------------------------------------------
   LEFT(text, n) → returns first n characters.
   RIGHT(text, n) → returns last n characters.

   Purpose:
   - Used for codes, prefixes, file names, etc.
   ============================================================ */
SELECT LEFT(title, 2) AS first_letter,
       RIGHT(title, 3) AS last_letter,
       title
FROM sakila.film;


/* ============================================================
   10. GROUPING by first or last letters of titles
   ------------------------------------------------------------
   Idea:
   - LEFT(title, 1) → first character of title
   - RIGHT(title, 1) → last character of title
   - GROUP BY → group based on these extracted characters

   Purpose:
   - Analyze how many films start/end with a particular letter.
   ============================================================ */
SELECT LEFT(title, 1) AS first_letter,
       RIGHT(title, 1) AS last_letter,
       COUNT(*) AS film_count
FROM sakila.film
GROUP BY LEFT(title, 1), RIGHT(title, 1)
ORDER BY film_count DESC;
/* ============================================================
   11. CASE Expression → Conditional Logic in SQL
   ------------------------------------------------------------
   CASE
       WHEN condition THEN result
       WHEN condition THEN result
       ELSE default_result
   END

   Purpose:
   - Works like IF / ELSE IF in programming.
   - Used to categorize or group data based on conditions.
   ============================================================ */

SELECT last_name,
       CASE
           WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M'
                THEN 'Group A-M'          -- names starting A to M
           WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z'
                THEN 'Group N-Z'          -- names starting N to Z
           ELSE 'Other'                   -- safety fallback
       END AS group_label
FROM sakila.customer;


/* ============================================================
   12. REPLACE() → Replace characters in text
   ------------------------------------------------------------
   REPLACE(text, old_value, new_value)

   Purpose:
   - Replace one character/word with another.
   - Useful for cleaning data, fixing typos, masking values.
   ============================================================ */

-- Replace letter 'A' with letter 'X' in the movie titles
SELECT title,
       REPLACE(title, 'A', 'X') AS cleaned_title
FROM sakila.film
WHERE title LIKE '%A%';    -- only titles that contain 'A'

/* ============================================================
   🔵 PART 1 — FUNCTIONS FROM YOUR NOTES (WITH DETAILED EXPLANATIONS)
   These are REPLACE, REGEXP, RIGHT, LEFT, CAST, UPDATE,
   FLOOR, CEILING, ROUND, RAND, POWER
   ============================================================ */


/* 🟣 1. REPLACE()  
   → Replaces all occurrences of a character/string with another.  
   Example: Replace all 'A' with 'X' in movie titles. */
SELECT title,
       REPLACE(title, 'A', 'X') AS replaced_title
FROM film
LIMIT 5;


/* 🟣 2. REGEXP  
   → Used to match patterns using regular expressions.  
   Example: Find last names that contain 3 consecutive vowels. */
SELECT customer_id, last_name
FROM customer
WHERE last_name REGEXP '[aeiouAEIOU]{3}';


/* 🟣 3. RIGHT()  
   → Extract characters from the RIGHT side of a string.  
   Example: Last 2 letters of movie title. */
SELECT title,
       RIGHT(title, 2) AS last_two_chars
FROM film
LIMIT 5;


/* 🟣 4. LEFT()  
   → Extract characters from the LEFT side of a string. */
SELECT title,
       LEFT(title, 3) AS first_three_chars
FROM film
LIMIT 5;


/* 🟣 5. CAST()  
   → Converts one datatype into another.  
   Example: Convert number to text. */
SELECT rental_rate,
       CAST(rental_rate AS CHAR) AS rental_rate_text
FROM film
LIMIT 5;


/* 🟣 6. UPDATE  
   → Used to update an existing value in a table.
   ⚠️ DO NOT RUN ON PRODUCTION DATABASES.
   Example: Change first name temporarily for testing. */
UPDATE customer
SET first_name = 'RAVI_TEST'
WHERE customer_id = 1;

/* Undo example */
UPDATE customer
SET first_name = 'MARY'
WHERE customer_id = 1;


/* 🟣 7. FLOOR()  
   → Rounds number DOWN to nearest integer.  
   Example: 4.99 → 4 */
SELECT rental_rate,
       FLOOR(rental_rate) AS rounded_down
FROM film
LIMIT 5;


/* 🟣 8. CEILING()  
   → Rounds number UP to next integer.  
   Example: 4.01 → 5 */
SELECT rental_rate,
       CEILING(rental_rate) AS rounded_up
FROM film
LIMIT 5;


/* 🟣 9. ROUND()  
   → Rounds number to nearest whole number.  
   Example: 4.39 → 4 | 4.79 → 5 */
SELECT ROUND(4.39) AS rounded_1,
       ROUND(4.79) AS rounded_2;


/* 🟣 10. RAND()  
   → Generates a random number between 0 and 1. */
SELECT RAND() AS random_value;


/* 🟣 11. POWER()  
   → Raises a number to a given power.  
   Example: 5² = 25 */
SELECT POWER(5, 2) AS squared_value;
 
 /* ============================================================
   🔵 PART 2 — EXTRA STRING FUNCTIONS NOT COVERED BY INSTRUCTOR
   Useful for interviews, projects, and SQL mastery
   ============================================================ */





/* 🟣 13. CONCAT_WS()  
   → Same as CONCAT but adds a separator automatically. */
SELECT CONCAT_WS('-', first_name, last_name, email) AS combined_info
FROM customer
LIMIT 5;


/* 🟣 15. TRIM(), LTRIM(), RTRIM()  
   → Remove spaces from left/right/both sides of text. */
SELECT TRIM('   Ravi Varma   ') AS cleaned_text;
SELECT LTRIM('     Hello') AS left_trimmed;
SELECT RTRIM('Hello     ') AS right_trimmed;


/* 🟣 16. INSTR()  
   → Returns the position of a substring inside a string. */
SELECT email,
       INSTR(email, '@') AS position_of_at
FROM customer
LIMIT 5;


/* 🟣 19. ELT()  
   → Returns item from list by its index. */
SELECT ELT(3, 'Apple', 'Banana', 'Cherry') AS third_item;


/* 🟣 20. FIELD()  
   → Returns index of a value inside a list. */
SELECT FIELD('PG', 'G', 'PG', 'R') AS position;


/* 🟣 21. FIND_IN_SET()  
   → Searches a CSV string ('A,B,C') to find index of value. */
SELECT FIND_IN_SET('PG', 'G,PG,R,NC-17') AS index_value;



/* 🟣 23. MAKE_SET()  
   → Creates a comma-separated list based on bit values.  
   Ex: 5 → 0101 (selects 1st and 3rd items) */
SELECT MAKE_SET(5, 'A', 'B', 'C', 'D') AS result;


/* 🟣 24. SPACE()  
   → Creates N spaces. */
SELECT CONCAT('Ravi', SPACE(5), 'Varma') AS spaced_name;


/* 18. QUOTE() → Adds quotes around a string */
SELECT QUOTE(first_name)
FROM customer
LIMIT 5;


/* 🟣 26. REPEAT()  
   → Repeat a string N times. */
SELECT REPEAT('*', 10) AS stars;





/* 🟣 28. HEX() & UNHEX()  
   → Convert text to hexadecimal and back. */
SELECT HEX('Ravi') AS hex_value;
SELECT UNHEX('52617669') AS original_text;


/* 🟣 29. ASCII()  
   → Shows ASCII code of the first character. */
SELECT ASCII('A') AS ascii_value;


/* 🟣 30. CHAR()  
   → Convert ASCII code into character. */
SELECT CHAR(65) AS letter;


/* 🟣 31. NULLIF()  
   → Returns NULL if both values are equal. */
SELECT NULLIF('abc', 'abc') AS result;


/* 🟣 32. COALESCE()  
   → Returns the first non-null value in the list. */
SELECT COALESCE(NULL, NULL, 'Ravi', 'UTD') AS output_value;
 
 /* 🟣 18. UNCOMPRESS() + COMPRESS()  
       → Compress or uncompress text data. */
SELECT UNCOMPRESS(COMPRESS('Ravi MySQL')) AS decompressed;
/* 🟣 9. SOUNDEX()  
      → Returns phonetic (sound-based) representation.  
      Useful for matching similar-sounding names. */
SELECT SOUNDEX('Ravi'), SOUNDEX('Ravee');


/* 🟣 10. DIFFERENCE()  
      → Compares SOUNDEX values of two words. */
SELECT DIFFERENCE('Ravi', 'Ravee') AS sound_similarity;



  
