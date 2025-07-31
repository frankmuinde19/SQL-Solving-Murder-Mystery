-- Solving the murder mystery 
SELECT  * 
FROM
    person
;

/** The crime was  was a ​murder​ that occurred 
sometime on ​Jan.15, 2018​ and 
that it took place in ​SQL City​**/
SELECT * 
FROM 
    crime_scene_report 
WHERE 
    date= '20180115'
AND 
    city = 'SQL City'
LIMIT 10;
/**Security footage shows that there were 2 witnesses.
The first witness lives at the last house on 
"Northwestern Dr". The second witness, named Annabel, 
lives somewhere on "Franklin Ave".**/

--first witness
SELECT * 
FROM 
    person 
WHERE 
    address_street_name = 'Northwestern Dr'
ORDER BY 
    address_number DESC ;
/**id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949**/

--second witness
SELECT * 
FROM 
    person 
WHERE 
    name LIKE '%Annabel%'
AND 
    address_street_name ='Franklin Ave'
;
/**id	name	license_id	address_number	address_street_name	ssn
16371	Annabel Miller	490173	103	Franklin Ave	318771143**/

SELECT * 
FROM 
    interview
WHERE 
    person_id = 14887
;
/**person_id	transcript
14887	I heard a gunshot and then saw a man run out.
 He had a "Get Fit Now Gym" bag. The membership number
  on the bag started with "48Z". Only gold members have
 those bags. The man got into a car with a plate that 
 included "H42W".**/
 SELECT * 
FROM 
    interview
WHERE 
    person_id = 16371;
/**person_id	transcript
16371	I saw the murder happen, and I recognized the 
killer from my gym when I was working out last week on 
January the 9th.**/

--from Mortys Evidence
 SELECT * 
FROM 
    get_fit_now_member
WHERE
     id 
LIKE
     '48Z%'
AND 
    membership_status = 'gold'
;
/**id	person_id	name	membership_start_date	membership_status
48Z7A	28819	Joe Germuska	20160305	gold
48Z55	67318	Jeremy Bowers	20160101	gold**/

/**from Annabel's**/
 SELECT * 
FROM get_fit_now_check_in
WHERE check_in_date = 20180109
;
/**there are 10 suspects 
Evaluating futher **/
SELECT * 
FROM get_fit_now_check_in
WHERE check_in_date = 20180109
AND membership_id 
IN ('48Z7A','48Z55')
;
/**--We've narrowed down to 2 suspects lets check ids from the Membership table**/

SELECT * 
FROM get_fit_now_member
WHERE 
     id 
IN ('48Z7A','48Z55')
;
/**id	person_id	name	membership_start_date	membership_status
48Z55	67318	Jeremy Bowers	20160101	gold
48Z7A	28819	Joe Germuska	20160305	gold**/
--We now use the persons table to to identify suspect
SELECT * 
FROM person
WHERE 
     id 
IN ('67318','28819')
;
/**id	name	license_id	address_number	address_street_name	ssn
28819	Joe Germuska	173289	111	Fisk Rd	138909730
67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279**/
--Lets use the drivers license table to identify by car plate number 
SELECT * 
FROM drivers_license
WHERE 
     id 
IN ('173289','423327')
;
/**id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS**/
--The licence description match!! 
--Our suspects is;
SELECT * 
FROM person
WHERE 
     license_id ='423327'
;
--Jeremy  Bowers was the Murderer
INSERT INTO solution VALUES (1, "Jeremy Bowers");

SELECT value FROM solution;
/**Congrats, you found the murderer! But wait, there's more.
.. If you think you're up for a challenge, try querying 
the interview transcript of the murderer to find the real villain
 behind this crime. If you feel especially confident in your SQL 
 skills, try to complete this final step with no more than 2 queries.
Use this same INSERT statement with your new suspect to 
check your answer.**/
SELECT *
FROM interview
WHERE person_id = 67318
;
/**person_id	transcript
67318	I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5" (65")
 or 5'7" (67"). She has red hair and she drives a Tesla Model S.
I know that she attended the 
SQL Symphony Concert 3 times in December 2017.**/

--Seems we have a new suspect!!, Lets get her too 
SELECT *
FROM 
    drivers_license
WHERE 
    height BETWEEN 65 AND 67 
AND 
    hair_color = 'red' 
AND 
    car_make = 'Tesla'
AND 
    car_model = 'Model S'
;
--seems we have  a list of 3 , lets use join statements
WITH 
    Suspect_list as (
SELECT *
FROM 
    drivers_license 
WHERE 
    height BETWEEN 65 AND 67 
AND 
    hair_color = 'red' 
AND 
    car_make = 'Tesla'
AND 
    car_model = 'Model S'
)
SELECT * 
FROM 
    facebook_event_checkin f
JOIN
     person p 
ON 
    f.person_id=p.id
JOIN
     drivers_license d
ON 
    p.license_id=d.id
WHERE
     f.event_name = 'SQL Symphony Concert'
AND 
    f.date 
BETWEEN  '20171201' AND  '20171231'
GROUP BY 
    person_id
HAVING 
    COUNT(*)= 3
;
/**person_id	event_id	event_name	date	id	name	license_id	address_number	address_street_name	ssn	id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
99716	1143	SQL Symphony Concert	20171206	99716	Miranda Priestly	202298	1883	Golden Ave	987756388	202298	68	66	green	red	female	500123	Tesla	Model S**/
INSERT INTO solution VALUES (1, "Miranda Priestly");

SELECT value FROM solution;
/**value
Congrats, you found the brains behind the murder! 
Everyone in SQL City hails you as the greatest SQL detective of all time. 
Time to break out the champagne!**/