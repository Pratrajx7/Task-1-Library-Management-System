---------- Project Title: Library Management System 

CREATE DATABASE library_management;
USE library_management;
--- Database Creation

CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100),
    AUTHOR VARCHAR(100),
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT
);
CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    PHONE_NO VARCHAR(15),
    ADDRESS VARCHAR(255),
    MEMBERSHIP_DATE DATE
);
CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);
--- Insert Data into Tables

INSERT INTO Books VALUES
(1, 'Wings of Fire', 'APJ Abdul Kalam', 'Biography', 1999, 3),
(2, 'Godaan', 'Munshi Premchand', 'Fiction', 1936, 2),
(3, 'The White Tiger', 'Aravind Adiga', 'Fiction', 2008, 1),
(4, 'Discovery of India', 'Jawaharlal Nehru', 'History', 1946, 4),
(5, 'Train to Pakistan', 'Khushwant Singh', 'Historical Fiction', 1956, 2),
(6, 'India After Gandhi', 'Ramachandra Guha', 'History', 2007, 3),
(7, 'Half Girlfriend', 'Chetan Bhagat', 'Romance', 2014, 1),
(8, '2 States', 'Chetan Bhagat', 'Romance', 2009, 1);

INSERT INTO Members VALUES
(101, 'Ravi Kumar', 'ravi.kumar@abc.com', '9876543210', 'Delhi', '2022-01-15'),
(102, 'Priya Sharma', 'priya.sharma@abc.com', '9876543211', 'Mumbai', '2022-03-10'),
(103, 'Amit Singh', 'amit.singh@abc.com', '9876543212', 'Lucknow', '2022-04-01'),
(104, 'Neha Verma', 'neha.verma@abc.com', '9876543213', 'Bangalore', '2023-02-05'),
(105, 'Suresh Patel', 'suresh.patel@abc.com', '9876543214', 'Ahmedabad', '2023-05-10');

INSERT INTO BorrowingRecords VALUES
(1, 101, 1, '2025-07-01', '2025-07-20'),
(2, 101, 2, '2025-07-15', NULL), -- overdue
(3, 102, 3, '2025-08-01', NULL),
(4, 103, 4, '2025-06-20', '2025-07-10'),
(5, 103, 5, '2025-06-22', NULL), -- overdue
(6, 104, 6, '2025-08-01', NULL),
(7, 104, 7, '2025-08-05', NULL),
(8, 104, 2, '2025-08-07', NULL),
(9, 102, 8, '2025-07-01', '2025-07-20');

----Information Retrieval:

a) Retrieve a list of books currently borrowed by a specific member (e.g., Ravi Kumar, ID = 101)

SELECT b.TITLE, b.AUTHOR
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
WHERE br.MEMBER_ID = 101 AND br.RETURN_DATE IS NULL;

b) Find members who have overdue books (borrowed more than 30 days ago, not
returned).

SELECT m.NAME, m.EMAIL, br.BOOK_ID, br.BORROW_DATE
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
WHERE br.RETURN_DATE IS NULL AND br.BORROW_DATE < CURRENT_DATE - INTERVAL '30' DAY;

c) Retrieve books by genre along with the count of available copies.

SELECT GENRE, COUNT(*) AS TOTAL_BOOKS, SUM(AVAILABLE_COPIES) AS TOTAL_COPIES
FROM Books
GROUP BY GENRE;

d) Find the most borrowed book(s) overall.

SELECT b.TITLE, COUNT(*) AS BORROW_COUNT
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY b.TITLE
ORDER BY BORROW_COUNT DESC
LIMIT 1;

e) Retrieve members who have borrowed books from at least three different genres.

SELECT m.MEMBER_ID, m.NAME
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
GROUP BY m.MEMBER_ID, m.NAME
HAVING COUNT(DISTINCT b.GENRE) >= 3;

--- Reporting and Analytics:

a) Calculate the total number of books borrowed per month.

SELECT FORMAT(BORROW_DATE, 'yyyy-MM') AS MONTH, COUNT(*) AS TOTAL_BORROWED
FROM BorrowingRecords
GROUP BY FORMAT(BORROW_DATE, 'yyyy-MM')
ORDER BY MONTH;

b) Find the top three most active members based on the number of books
borrowed.

SELECT m.NAME, COUNT(*) AS BORROWED_COUNT
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
GROUP BY m.NAME
ORDER BY BORROWED_COUNT DESC
LIMIT 3;

c) Retrieve authors whose books have been borrowed at least 10 times.

SELECT b.AUTHOR, COUNT(*) AS BORROW_COUNT
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY b.AUTHOR
HAVING COUNT(*) >= 10;

d) Identify members who have never borrowed a book.

SELECT m.NAME
FROM Members m
LEFT JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
WHERE br.BORROW_ID IS NULL;










