
DROP TABLE assignments;
DROP TABLE animals;
DROP TABLE staff;
DROP TABLE enclosures;

   CREATE TABLE enclosures (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    capacity INT,
    closedForMaintenance BOOLEAN
   );

   CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    employeeNumber INT
   );

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255),
    age INT,
    enclosure_id INT REFERENCES enclosures(id));

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    employeeId INT REFERENCES staff(id),
    enclosureId INT REFERENCES enclosures(id),
    day VARCHAR(255)
    );
 
-- psql -d safari -f safari_lab.sql


INSERT INTO enclosures (name,capacity,closedForMaintenance)VALUES(
    'big cat field',
    20,
    false
);
INSERT INTO enclosures (name,capacity,closedForMaintenance)VALUES(
    'amazing bears',
    20,
    true
);

INSERT INTO staff (name,employeeNumber)VALUES(
    'Captain Rik',
    123
);
INSERT INTO staff (name,employeeNumber)VALUES(
    'John',
    456
);
INSERT INTO staff (name,employeeNumber)VALUES(
    'Rachel',
    789
);

INSERT INTO animals(name,type,age,enclosure_id)VALUES(
'Tony',
'Tiger',
15,
1
);
INSERT INTO animals(name,type,age,enclosure_id)VALUES(
'Simba',
'Lion',
10,
1
);
INSERT INTO animals(name,type,age,enclosure_id)VALUES(
'Tom',
'Tiger',
8,
1
);
INSERT INTO animals(name,type,age,enclosure_id)VALUES(
'Barry',
'Bear',
15,
2
);


INSERT INTO assignments(employeeId,enclosureId,day)VALUES(
    1,
    1,
    'Tuesday'
);
INSERT INTO assignments(employeeId,enclosureId,day)VALUES(
    2,
    1,
    'Wednesday'
);
INSERT INTO assignments(employeeId,enclosureId,day)VALUES(
    3,
    2,
    'Wednesday'
);

-- MVP task:
-- The names of the animals in a given enclosure

-- SELECT animals.name FROM animals LEFT JOIN enclosures ON enclosures.id=animals.enclosure_id WHERE enclosures.id=1;
-- better to use inner join if might have missing values:
SELECT animals.name FROM animals INNER JOIN enclosures ON enclosures.id=animals.enclosure_id WHERE enclosures.id=1;

-- The names of the staff working in a given enclosure
-- SELECT staff.name FROM staff INNER JOIN assignments ON staff.id=assignments.employeeId 
-- INNER JOIN enclosures ON assignments.enclosureId=enclosures.id WHERE enclosures.id=1;
-- a shorter solution:
SELECT staff.name FROM staff INNER JOIN assignments ON assignments.employeeId=staff.id WHERE enclosureId=1;

--  EXTENSION:

-- The names of staff working in enclosures which are closed for maintenance
SELECT staff.name FROM staff INNER JOIN assignments ON staff.id=assignments.employeeId 
INNER JOIN enclosures ON assignments.enclosureId=enclosures.id WHERE enclosures.closedForMaintenance=true;

-- The name of the enclosure where the oldest animal lives. 
-- If there are two animals who are the same age choose the first one alphabetically.
SELECT enclosures.name FROM enclosures INNER JOIN animals ON animals.enclosure_id=enclosures.id
ORDER BY animals.age DESC, enclosures.name ASC LIMIT 1;

-- The number of different animal types a given keeper has been assigned to work with.
SELECT COUNT( DISTINCT animals.type) FROM animals INNER JOIN enclosures ON animals.enclosure_id=enclosures.id 
INNER JOIN assignments ON assignments.enclosureId=enclosures.id WHERE employeeId=1;

-- The number of different keepers who have been assigned to work in a given enclosure
SELECT COUNT( staff.id) FROM staff INNER JOIN assignments ON staff.id=assignments.employeeId 
INNER JOIN enclosures ON assignments.enclosureId=enclosures.id WHERE enclosures.id=1;

-- The names of the other animals sharing an enclosure with a given animal 
-- (eg. find the names of all the animals sharing the big cat field with Tony)
SELECT  animals.name FROM animals INNER JOIN enclosures ON animals.enclosure_id=enclosures.id 
GROUP BY enclosures.name, animals.name HAVING enclosures.name='big cat field';