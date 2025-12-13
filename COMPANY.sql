-------------------------------------------------------
--              CREATE ALL TABLES 
-------------------------------------------------------

-- Creating DEPARTMENT Table.
CREATE TABLE DEPARTMENT(
D_number INTEGER   NOT NULL,
D_name VARCHAR(30) NOT NULL,
D_description VARCHAR(200) ,
PRIMARY KEY(D_number),
UNIQUE(D_name)
);


-- Creating EMPLOYEE Table.
CREATE TABLE EMPLOYEE (
E_id INTEGER     NOT NULL,
F_name VARCHAR(15) NOT NULL,
L_name VARCHAR(15) NOT NULL,
email VARCHAR(50)     NOT NULL,
phone VARCHAR(15)     NOT NULL,
D_number INTEGER   NOT NULL,
PRIMARY KEY(E_id),
UNIQUE(email),
UNIQUE(phone),
FOREIGN KEY(D_number) REFERENCES DEPARTMENT(D_number)
);
-- Creating CUSTOMER Table.
CREATE TABLE CUSTOMER(
E_id INTEGER NOT NULL,
organization VARCHAR(50),
PRIMARY KEY(E_id),
FOREIGN KEY(E_id) REFERENCES EMPLOYEE(E_id)   ON DELETE CASCADE
);
-- Creating SUPPORT_AGENT Table.
CREATE TABLE SUPPORT_AGENT(
E_id INTEGER NOT NULL,
role VARCHAR(20) NOT NULL,
PRIMARY KEY(E_id),
FOREIGN KEY(E_id) REFERENCES EMPLOYEE(E_id)   ON DELETE CASCADE
);
-- Creating SA_SKILLS Table. multi valued attrbute for support agent
CREATE TABLE SA_SKILLS(
SA_id INTEGER NOT NULL,
skill VARCHAR(30) NOT NULL,
PRIMARY KEY(SA_id,skill),
FOREIGN KEY(SA_id) REFERENCES SUPPORT_AGENT(E_id)   ON DELETE CASCADE
);



-- Creating TICKET Table
-- Note: R_E_id is the Requester (Employee), assigned_SA_id is the Agent.
CREATE TABLE TICKET(
    T_id NUMBER(4) PRIMARY KEY,
    T_title VARCHAR2(100) NOT NULL,
    T_description VARCHAR2(200),
    T_status VARCHAR2(20) CHECK (T_status IN ('Open', 'In Progress', 'Closed')),
    T_priority VARCHAR2(20) CHECK (T_priority IN ('Low', 'Medium', 'High', 'Critical')),
    T_create_date DATE,
    T_resolution_date DATE,
    R_E_id NUMBER NOT NULL,
    assigned_SA_id NUMBER NOT NULL,
    D_number NUMBER NOT NULL,
    CONSTRAINT fk_ticket_requester FOREIGN KEY (R_E_id) REFERENCES EMPLOYEE(E_id),
    CONSTRAINT fk_ticket_agent FOREIGN KEY (assigned_SA_id) REFERENCES SUPPORT_AGENT(E_id),
    CONSTRAINT fk_ticket_dept FOREIGN KEY (D_number) REFERENCES DEPARTMENT(D_number) ON DELETE CASCADE
);

-- Creating ATTACHMENT Table (Weak Entity)
CREATE TABLE ATTACHMENT (
    A_file_name VARCHAR2(100) NOT NULL,
    T_id NUMBER NOT NULL,
    A_file_type VARCHAR2(20),
    A_upload_date DATE,
    PRIMARY KEY (A_file_name, T_id),
    CONSTRAINT fk_attach_ticket FOREIGN KEY (T_id) REFERENCES TICKET(T_id) ON DELETE CASCADE
);

-- Creating KNOWLEDGE_BASE_ARTICLE Table
CREATE TABLE KNOWLEDGE_BASE_ARTICLE (
    KBA_id NUMBER PRIMARY KEY,
    KBA_title VARCHAR2(100) NOT NULL,
    KBA_content VARCHAR2(2000),
    KBA_category VARCHAR2(50),
    KBA_created_date DATE,
    SA_id NUMBER NOT NULL,
    CONSTRAINT fk_kba_agent FOREIGN KEY (SA_id) REFERENCES SUPPORT_AGENT(E_id)
);

-- Creating TICKET_LINKED_TO_KBA Table. The (M:N Relationship)
CREATE TABLE TICKET_LINKED_TO_KBA (
    T_id NUMBER,
    KBA_id NUMBER,
    PRIMARY KEY (T_id, KBA_id),
    CONSTRAINT fk_link_ticket FOREIGN KEY (T_id) REFERENCES TICKET(T_id) ON DELETE CASCADE,
    CONSTRAINT fk_link_kba FOREIGN KEY (KBA_id) REFERENCES KNOWLEDGE_BASE_ARTICLE(KBA_id) ON DELETE CASCADE
);

-------------------------------------------------------
--      INSERT INITIAL DATA INTO ALL TABLES
-------------------------------------------------------

-- 1. INSERT DATA INTO DEPARTMENT TABLE
INSERT INTO DEPARTMENT VALUES (1, 'IT', 'Handles technical and help desk support');
INSERT INTO DEPARTMENT VALUES (2, 'HR', 'Human resources and employee relations');
INSERT INTO DEPARTMENT VALUES (3, 'FINANCE', 'Financial and accounting department');
INSERT INTO DEPARTMENT VALUES (4, 'Marketing', 'Marketing and communication');
INSERT INTO DEPARTMENT VALUES (5, 'Risk Management', 'Identifying and mitigating organizational risks');
INSERT INTO DEPARTMENT VALUES (6, 'Quality Assurance',
'Ensures process quality, standards compliance, and continuous improvement within the organization');

-- 2. INSERT DATA INTO EMPLOYEE TABLE
INSERT INTO EMPLOYEE VALUES (100, 'Reham',   'Mobarak',  'rere@icloud.com',   '0502000001', 1);
INSERT INTO EMPLOYEE VALUES (101, 'Nadeen',  'yahya',  'nadeen@gmail.com',  '0500000002', 1);
INSERT INTO EMPLOYEE VALUES (102, 'Mohamad',  'Fahad', 'mmm@hotmail.com',  '0500000003', 2);
INSERT INTO EMPLOYEE VALUES (103, 'Leen',  'Khaled', 'lno@icloud.com',  '0500000004', 5);
INSERT INTO EMPLOYEE VALUES (104, 'Ahmad',  'Yousef', 'Ahmad22@gmail.com',  '05000010005', 3);
INSERT INTO EMPLOYEE VALUES (105, 'Fahad', 'Khalid', 'fahad@gmail.com', '0500000006', 6);
INSERT INTO EMPLOYEE VALUES (106, 'Ali',   'Saleh',  'ali@gmail.com',   '0500000001', 4);
INSERT INTO EMPLOYEE VALUES (107, 'Sara',  'Ahmed',  'sara@icloud.com',  '0500001112', 1);
INSERT INTO EMPLOYEE VALUES (108, 'Omar',  'Nasser', 'omar@gmail.com',  '0500001113', 2);
INSERT INTO EMPLOYEE VALUES (109, 'Lama',  'Hassan', 'lama@outlook.com',  '0500001114', 3);
INSERT INTO EMPLOYEE VALUES (110, 'Reem',  'Yousef', 'reem@icloud.com',  '0500001115', 4);
INSERT INTO EMPLOYEE VALUES (111, 'Sama', 'Ali', 'soso@gmail.com', '0500001116', 6);

-- 3. INSERT DATA INTO CUSTOMER TABLE
INSERT INTO CUSTOMER VALUES (111, 'HQ');
INSERT INTO CUSTOMER VALUES (102, 'Riyadh Branch');
INSERT INTO CUSTOMER VALUES (103, 'Dammam Branch');
INSERT INTO CUSTOMER VALUES (104, 'Jeddah Branch');
INSERT INTO CUSTOMER VALUES (105, 'HQ');
INSERT INTO CUSTOMER VALUES (107, 'Riyadh Branch');

-- 4. INSERT DATA INTO SUPPORT_AGENT TABLE
INSERT INTO SUPPORT_AGENT VALUES (100, 'Support Engineer');
INSERT INTO SUPPORT_AGENT VALUES (101, 'Team Leader');
INSERT INTO SUPPORT_AGENT VALUES (106, 'Senior Agent');
INSERT INTO SUPPORT_AGENT VALUES (108, 'Support Engineer');
INSERT INTO SUPPORT_AGENT VALUES (109, 'Junior Agent');
INSERT INTO SUPPORT_AGENT VALUES (110, 'Senior Agent');

-- 5. INSERT DATA INTO SA_SKILLS TABLE
INSERT INTO SA_SKILLS VALUES (100, 'Network Troubleshooting');
INSERT INTO SA_SKILLS VALUES (100, 'Email Support');
INSERT INTO SA_SKILLS VALUES (101, 'Hardware Repair');
INSERT INTO SA_SKILLS VALUES (106, 'System Administration');
INSERT INTO SA_SKILLS VALUES (101, 'Database Support');
INSERT INTO SA_SKILLS VALUES (110, 'VPN Configuration');

-- 6. INSERT DATA INTO TICKET TABLE
INSERT INTO TICKET VALUES (1001, 'Login Issue', 'I cannot login to email', 'Open', 'High', TO_DATE('2025-11-20','YYYY-MM-DD'), NULL, 111, 100, 1);
INSERT INTO TICKET VALUES (1002, 'Email not working', 'I cannot send or receive emails', 'Closed', 'Medium', TO_DATE('2025-11-15','YYYY-MM-DD'), TO_DATE('2025-11-16','YYYY-MM-DD'), 101, 100, 1);
INSERT INTO TICKET VALUES (1003, 'Slow Wifi', 'The internet keeps disconnecting on me', 'In Progress', 'Medium', TO_DATE('2025-11-21','YYYY-MM-DD'), NULL, 103, 101, 1);
INSERT INTO TICKET VALUES (1004, 'System performance issue', 'The computer is running very slow', 'Open', 'Critical', TO_DATE('2025-11-22','YYYY-MM-DD'), NULL, 105, 106, 1);
INSERT INTO TICKET VALUES (1005, 'Software Install Issue', 'I need Oracle to be installed', 'Closed', 'Low', TO_DATE('2025-11-10','YYYY-MM-DD'), TO_DATE('2025-11-11','YYYY-MM-DD'), 105, 108, 1);
INSERT INTO TICKET VALUES (1006, 'Forgot password request', 'I need to reset my password', 'Open', 'Low', TO_DATE('2025-11-22','YYYY-MM-DD'), NULL, 110, 100, 1);

-- 7. INSERT DATA INTO ATTACHMENT TABLE
INSERT INTO ATTACHMENT VALUES ('screenshot_login_error.png', 1001, 'PNG', TO_DATE('2025-11-20','YYYY-MM-DD'));
INSERT INTO ATTACHMENT VALUES ('screenshot_email_not_working.png', 1002, 'PNG', TO_DATE('2025-11-15','YYYY-MM-DD'));
INSERT INTO ATTACHMENT VALUES ('Wifi_error_messages.txt', 1003, 'txt', TO_DATE('2025-11-21','YYYY-MM-DD'));
INSERT INTO ATTACHMENT VALUES ('system_report.pdf', 1004, 'PDF', TO_DATE('2025-11-22','YYYY-MM-DD'));
INSERT INTO ATTACHMENT VALUES ('screenshot_install_error.png', 1005, 'PNG', TO_DATE('2025-11-10','YYYY-MM-DD'));
INSERT INTO ATTACHMENT VALUES ('screenshot_password_error.jpg', 1006, 'JPG', TO_DATE('2025-11-22','YYYY-MM-DD'));

-- 8. INSERT DATA INTO KNOWLEDGE_BASE_ARTICLE TABLE
INSERT INTO KNOWLEDGE_BASE_ARTICLE VALUES (500, 'Email Login', 'Check password, server status, and network connection.', 'Software', TO_DATE('2025-05-01','YYYY-MM-DD'), 106);
INSERT INTO KNOWLEDGE_BASE_ARTICLE VALUES (501, 'Fix Email', 'Check email server status, verify login credentials, and clear email application cache.', 'Hardware', TO_DATE('2025-01-15','YYYY-MM-DD'), 100);
INSERT INTO KNOWLEDGE_BASE_ARTICLE VALUES (502, 'Wifi Troubleshooting', 'Check router power and connections, restart device, and verify correct network password.', 'Network', TO_DATE('2025-02-01','YYYY-MM-DD'), 108);
INSERT INTO KNOWLEDGE_BASE_ARTICLE VALUES (503, 'Oracle Install Guide', 'Run setup.exe', 'Software', TO_DATE('2025-03-01','YYYY-MM-DD'), 101);
INSERT INTO KNOWLEDGE_BASE_ARTICLE VALUES (504, 'Common System Performance Optimization', 'Try to: 1. Restart computer 2.Close unnecessary applications 3. Clear browser cache 4.Check for Windows/Mac updates', 'Network', TO_DATE('2025-04-01','YYYY-MM-DD'), 109);
INSERT INTO KNOWLEDGE_BASE_ARTICLE VALUES (505, 'Reset Password', 'Steps to Reset Your Password: 1.Visit the Login Page: Go to the login page of your email account. 2.Click on "Forgot Password"and change your password' , 'Security', TO_DATE('2025-01-01','YYYY-MM-DD'), 100);

-- 9. INSERT DATA INTO TICKET_LINKED_TO_KBA TABLE
INSERT INTO TICKET_LINKED_TO_KBA VALUES (1001, 500);
INSERT INTO TICKET_LINKED_TO_KBA VALUES (1002, 501);
INSERT INTO TICKET_LINKED_TO_KBA VALUES (1003, 502);
INSERT INTO TICKET_LINKED_TO_KBA VALUES (1005, 503);
INSERT INTO TICKET_LINKED_TO_KBA VALUES (1003, 504);
INSERT INTO TICKET_LINKED_TO_KBA VALUES (1001, 505);


-------------------------------------------------------
--              CREATE VIEWS 
-------------------------------------------------------

--View 1: TICKET_SUMMARY_VIEW Description: This view joins the Ticket table with Employees (Requester)
--         and Support Agents to give a readable summary of all tickets, showing names instead of IDs.

CREATE VIEW TICKET_SUMMARY_VIEW(E_Name, T_Title, T_Description, SA_Name) AS
SELECT 
    e.F_name, t.T_title, t.T_description, sa_emp.F_name
FROM 
      TICKET t
    JOIN EMPLOYEE e
        ON t.R_E_id = e.E_id
    JOIN SUPPORT_AGENT sa
        ON t.assigned_SA_id = sa.E_id
    JOIN EMPLOYEE sa_emp
        ON sa.E_id = sa_emp.E_id;


--View 2: AGENT_PERFORMANCE_VIEW Description: This view shows how many tickets each agent has handled.
   
CREATE VIEW AGENT_PERFORMANCE_VIEW(Agent_Name, No_Of_Teckit) AS
SELECT 
    e.F_name, COUNT(*)
FROM 
    SUPPORT_AGENT sa
    JOIN TICKET t ON sa.E_id = t.assigned_SA_id
    LEFT JOIN EMPLOYEE e ON e.E_id = sa.E_id
GROUP BY 
     e.F_name;
  
     SELECT *
     FROM AGENT_PERFORMANCE_VIEW;



-------------------------------------------------------
--              CREATE ALL QUERIES 
-------------------------------------------------------

--Query 1: List all "Critical" priority tickets that are currently "Open".

SELECT c_emp.F_name AS C_Name, t.T_title, t.T_priority, sa_emp.F_name AS SA_Name, t.T_status
FROM TICKET t
JOIN EMPLOYEE c_emp
    ON t.R_E_id = c_emp.E_id
JOIN SUPPORT_AGENT  sa
    ON sa.E_id =  t.assigned_SA_id
JOIN EMPLOYEE sa_emp
    ON sa_emp.E_id = sa.E_id
WHERE t.T_status = 'Open' AND T_priority = 'Critical';


--Query 2: Find all tickets requested by customers in the "IT" department.

SELECT c_emp.F_name AS C_Name, t.T_title, d.D_name
FROM TICKET t
JOIN DEPARTMENT d
    ON t.D_number = d.D_number
JOIN EMPLOYEE c_emp
    ON c_emp.E_id = t.R_E_id
WHERE d.D_name = 'IT';

--Query 3: List details of tickets that have attachments.

SELECT  t.T_id,
        t.T_title ,
        t.T_status ,
        t.T_priority ,
        t.T_create_date ,
        t.T_resolution_date ,
        c_emp.F_name AS C_Name,
        sa_emp.F_name AS SA_Name ,
        t.D_number,
        a.A_file_name
FROM TICKET t
JOIN ATTACHMENT a 
    ON t.T_id = a.T_id
JOIN EMPLOYEE c_emp
    ON c_emp.E_id = t.R_E_id
JOIN SUPPORT_AGENT  sa
    ON sa.E_id =  t.assigned_SA_id
JOIN EMPLOYEE sa_emp
    ON sa_emp.E_id = sa.E_id;

-- Query 4: Find Knowledge Base Articles created after Jan 1st, 2025.

SELECT KBA_id, KBA_title, KBA_category
FROM KNOWLEDGE_BASE_ARTICLE
WHERE KBA_created_date > TO_DATE('2025-01-01', 'YYYY-MM-DD');

-- Query 5: Count how many tickets each Department has generated.

SELECT d.D_name, COUNT(t.T_id)
FROM DEPARTMENT d
LEFT JOIN TICKET t ON d.D_number = t.D_number
GROUP BY d.D_name;

-- Query 6: Retrieve the names of support agents along with their departments and the number of skills assigned to each agent.

SELECT e.F_name AS First_name, e.L_name AS Last_name ,d.d_name AS Department_name, COUNT(sk.skill) AS skills_count
FROM  SUPPORT_AGENT sa, DEPARTMENT d,SA_SKILLS sk, EMPLOYEE e
WHERE sa.e_id=e.e_id AND e.d_number=d.d_number AND sk.sa_id=sa.e_id
GROUP BY e.F_name, e.L_name, d.D_name;

-- Query 7: Display departments that currently have unresolved tickets (Open or In Progress) and the total number of such tickets.

SELECT d.D_name, COUNT(t.T_id) AS unresolved_tickets
FROM DEPARTMENT d,TICKET t 
WHERE d.D_number=t.D_number AND t.T_status IN ('Open', 'In Progress')
GROUP BY d.D_name;

-- Query 8: Display the top three departments that generate the highest number of tickets in the system.

SELECT *
FROM (
    SELECT d.D_name AS department_name,COUNT(l.T_id) AS kb_usage_count
    FROM DEPARTMENT d, TICKET t, TICKET_LINKED_TO_KBA l
    WHERE d.D_number = t.D_number AND t.T_id = l.T_id
    GROUP BY d.D_name ORDER BY kb_usage_count DESC
)
WHERE ROWNUM <= 3;

-- Query 9: Show the number of employees working in each department.
SELECT d.D_name AS department_name, COUNT(e.E_id) AS Num_of_employees
FROM DEPARTMENT d,
     EMPLOYEE e
WHERE d.D_number = e.D_number
GROUP BY d.D_name;
