from sqlalchemy import create_engine, text
import pandas as pd

# STRING = "dbmsname+itspackage://username:password@host:port/dbname"
connection_string = 'postgresql+psycopg2://postgres:pgjana1234@localhost:5432/Employee : intern 1a'
engine = create_engine(connection_string)


"""
a)	Read the table employees. Find the employees and their managers using the employee_id and manager_id. 
    Return employee_first_name and manager_first_name. Load the result to the table tgt_employee_approvers. 
    Add the logic to delete and load the data if the table exists.
"""

def solution_a():
    select_command = """
        SELECT m.first_name AS Employee_first_name, e.first_name AS Manager_first_name
        FROM employee AS e
        JOIN employee AS m
        ON e.employee_id = m.manager_id;
    """

    with engine.begin() as conn:                                  # engine.begin() auto commits at end
        df = pd.read_sql(select_command, conn)
        conn.execute(text("""
            DROP TABLE IF EXISTS tgt_employee_approvers;
            CREATE TABLE tgt_employee_approvers (
                manager_first_name VARCHAR(50),
                employee_first_name VARCHAR(50)
            );
        """))

        for i, row in df.iterrows():
            conn.execute(text("""
                INSERT INTO tgt_employee_approvers (manager_first_name, employee_first_name)
                VALUES (:manager_first_name, :employee_first_name) 
            """), {
                'manager_first_name': row['manager_first_name'],
                'employee_first_name': row['employee_first_name']
            })
            print(i, row['manager_first_name'], row['employee_first_name'])



# solution_a()

"""
b)	Read the tables employees and job_history. Find those employees who earn $12000 and above. 
    Return employee_id, start_date, end_date and job_id. Write the result to a CSV file export_top_emp_sal.csv
"""

def solution_b():
    command = """
        SELECT e.employee_id, jh.start_date, jh.end_date, jh.job_id
        FROM employee AS e
        INNER JOIN job_history AS jh
        ON e.employee_id = jh.employee_id
        WHERE e.salary > 12000;
    """
    with engine.begin() as conn:
        df = pd.read_sql(command, conn)
        df.to_csv('csv/export_top_emp_sal.csv', index=False)


# solution_b()


"""
c)	Read the table employees and departments Find the number of employees in each department. 
    Return department_id, department_name, no_of_employees and the current_time. 
    Write the result to the table tgt_employee_count.
"""

def solution_c():
    create_command = """
        DROP TABLE IF EXISTS tgt_employee_count;
        CREATE TABLE tgt_employee_count (
            department_id INT,
            department_name VARCHAR(50),
            no_of_employees INT,
            time_current TIMESTAMP
        );
    """
    select_command = """
        SELECT
            e.department_id, 
            d.department_name, 
            COUNT(e.first_name) AS employee_count, 
            NOW() 
        FROM department AS d
        INNER JOIN employee AS e
        ON e.department_id = d.department_id
        GROUP BY d.department_name, e.department_id;
    """

    with engine.begin() as conn:
        df = pd.read_sql(select_command, conn)
        conn.execute(text(create_command))

        for i, row in df.iterrows():
            conn.execute(text("""
                INSERT INTO tgt_employee_count (department_id, department_name, no_of_employees, time_current)
                VALUES (:dept_id, :dept_name, :emp_count, :time);
            """), {
                'dept_id': row['department_id'],
                'dept_name': row['department_name'],
                'emp_count': row['employee_count'],
                'time': row['now']
            })
            print(i, row['department_id'], row['department_name'], row['employee_count'], row['now'])


# solution_c()


"""
d)	Read the table employees and departments and find the employee with 2nd highest salary from each department. 
    Return Employee first_name, last_name, salary, department_name. 
    Write the result to a file export_employee_high_sal.csv.
"""

def solution_d():
    select_command = """
        SELECT first_name, second_name, salary, department_name
        FROM (
            SELECT  
                e.first_name,
                e.second_name,
                e.salary, 
                d.department_name,
                ROW_NUMBER() OVER(PARTITION BY d.department_name ORDER BY e.salary DESC) AS rn
            FROM employee AS e
            INNER JOIN department AS d
            ON e.department_id = d.department_id
        ) AS iq
        WHERE iq.rn = 2;
    """
    with engine.begin() as conn:
        df = pd.read_sql(select_command, conn)
        df.to_csv('csv/export_employee_high_sal.csv', index=False)

# solution_d()

"""
e)	Analyze the job_history and employees tables to find employees who have worked in more than one department. 
    For each employee, return employee_id, first_name, last_name, number_of_departments, and departments_list. 
    Write the result to a file employees_multiple_departments.csv.
"""

def solution_e():
    select_command = """
        SELECT 
            e.employee_id, 
            e.first_name,
            e.second_name, 
            jh.department_id,
            COUNT(DISTINCT(jh.department_id)) AS number_of_departments,
            STRING_AGG(d.department_name, ', ') AS departments_list
        FROM employee AS e
        INNER JOIN job_history AS jh
        ON e.employee_id = jh.employee_id
        INNER JOIN department AS d
        ON d.department_id = jh.department_id
        GROUP BY e.employee_id, e.first_name, jh.department_id, jh.job_id
        HAVING COUNT(DISTINCT(jh.department_id)) > 1;
    """
    with engine.begin() as conn:
        df = pd.read_sql(select_command, conn)
        df.to_csv('csv/employees_multiple_departments.csv', index=False)
        # print(list(df.index)) -> to check if there are any rows returned

solution_e()


"""
f)	Identify the top 5 employees with the highest total compensation (salary + commission) in each department. 
    For each department, return department_id, department_name, employee_id, first_name, last_name, total_compensation. 
    Write the result to the table tgt_top_compensations.
"""

def solution_f():
    select_command = """
        SELECT department_id, department_name, employee_id, first_name, second_name, total_compensation 
        FROM(
            SELECT 
                e.department_id,
                d.department_name,
                e.employee_id,
                e.first_name, 
                e.second_name, 
                (e.salary + COALESCE(e.commission_pct, 0)) AS total_compensation,
                ROW_NUMBER() OVER(
                    PARTITION BY d.department_name ORDER BY (
                        e.salary + COALESCE(e.commission_pct, 0)) DESC
                    ) AS rn
            FROM employee AS e
            INNER JOIN department AS d
            ON e.department_id = d.department_id
        ) AS iq
        WHERE iq.rn < 6;
    """
    create_command = """
        DROP TABLE IF EXISTS tgt_top_compensations;
        CREATE TABLE tgt_top_compensations (
            department_id INT,
            department_name VARCHAR(100),
            employee_id INT,
            first_name VARCHAR(50),
            last_name VARCHAR(50),
            total_compensation FLOAT
        );
    """

    with engine.begin() as conn:
        df = pd.read_sql(select_command, conn)
        conn.execute(text(create_command))

        if list(df.index):
            for _, row in df.iterrows():
                conn.execute(text("""
                    INSERT INTO tgt_top_compensations (
                        department_id, department_name, employee_id, first_name, last_name, total_compensation
                    ) VALUES (:dept_id, :dept_name, :emp_id, :first_name, :last_name, :total_comp)
                """), {
                    'dept_id': row['department_id'],
                    'dept_name': row['department_name'],
                    'emp_id': row['employee_id'],
                    'first_name': row['first_name'],
                    'last_name': row['second_name'],
                    'total_comp': row['total_compensation']
                })

# solution_f()


"""
g)	Analyze the average salary for each job title in each department. 
    Return department_id, department_name, job_id, job_title, and average_salary. 
    Write the result to the table tgt_avg_salary_by_job_title.
"""

def solution_g():
    select_command = """
        SELECT 
            d.department_id, 
            d.department_name, 
            j.job_id, 
            j.job_title, 
            ((j.min_salary + j.max_salary) / 2) AS average_salary
        FROM employee AS e
        INNER JOIN department AS d
        ON e.department_id = d.department_id
        INNER JOIN job AS j
        ON j.job_id = e.job_id
        GROUP BY 	
            d.department_id, 
            d.department_name, 
            j.job_id, 
            j.job_title
        ORDER BY d.department_id;
    """
    create_command = """
        DROP TABLE IF EXISTS tgt_avg_salary_by_job_title;
        CREATE TABLE tgt_avg_salary_by_job_title (
            department_id INT,
            department_name VARCHAR(100),
            job_id VARCHAR(20),
            job_title VARCHAR(200),
            average_salary FLOAT
        )
    """
    with engine.begin() as conn:
        df = pd.read_sql(select_command, conn)
        conn.execute(text(create_command))

        if list(df.index):
            for _, row in df.iterrows():
                conn.execute(text("""
                    INSERT INTO tgt_avg_salary_by_job_title (
                        department_id, department_name, job_id, job_title, average_salary)
                    VALUES (:dept_id, :dept_name, :job_id, :job_title, :avg_sal)
                """), {
                    'dept_id': row['department_id'],
                    'dept_name': row['department_name'],
                    'job_id': row['job_id'],
                    'job_title': row['job_title'],
                    'avg_sal': row['average_salary']
                })

solution_g()

















