
--Subject code: 32606, 1st semester, year:2022, Name: Mahjabeen Mohiuddin, Email: mahjabeenmohiuddin@student.uts.edu.au, Student Id: 24610507, Course: Data Science and Innovation.
--
-- Online Book Store Database.
--
--This database is based on the concept of an Online Book Store. 
--The books written by the authors are based on the categories "Fantasy, Science Fiction, Action & Adventure, Mystery, Horror, Thriller & Suspense, Humor".
--When a customer creates his/ her account on this online bookstore, the customer's credentials are saved in the database of this bookstore and each distinct id will be created for each customer and it is used as a reference to customer details.
--Customers have to select their desired book/ books from the "Book Collection" page by clicking on the Book Collection button given on the web page.
--After the payment is made by the customer, the purchase id gets created and all the details related to the customer and the book being purchased are entered into "Purchase Information", it also contains the id of an employee who is going to process this order.
--Employees of a BookStore can contact the respective book publishing houses to order the books sold by the website. To order the list of books employees of BookStore may be made to speak to  executives of different departments of Publishing house.
--If the publisher has any query regarding the quantity to be sent by him, can speak to either one employee or two to three employees who can give him complete details of the order he received. 
--The books sold by the Online Book Store website are from different publishing houses and each publishing house is assigned the distinct publisher id.
--The website also includes the authors of books being sold by them, to help customers identify and find the books written by which authors, the list of author names along with their id is given with refrence to book id.
--Book sold on this website is written by only one author.
--The employees of the Online Book Store holds different positions in the company. The employees here reports to their managers.

drop view  BookinGenres  cascade;
drop view  OrderDetails  cascade;

drop  table  Book_Genres  cascade;
drop  table  Author_Details   cascade;
drop table Book_Publisher   cascade;
drop  table  Book_Collection  cascade;
drop table Contact_Publisher cascade; 
drop table Employee_Information cascade;
drop table Customer_Information   cascade;
drop table Purchase_Information   cascade;




create table  Book_Genres
( 
   Genre_Id  smallint,

   Genre_Name  character varying(40) not null,
   Genre_Discription character varying not null,
   
   constraint Book_Genrespk primary key(Genre_Id)
   
   
 );


 
create table Author_Details
(
 Author_Id	smallint,
 Author_Name	character varying(40) not null,
 Country	character varying(40),

 
 constraint Author_Detailspk primary key (Author_Id)
);

create table Book_Publisher
(
Publisher_Id smallint,
Publication	 character varying(40),
Contact_Person_Name character varying(40),
Address  character varying,
Suburb   character varying,
State character varying,
Country varchar,
Phone_No varchar(11),
Emaild_ID character varying(40),

constraint Book_Publisherpk primary key(Publisher_Id),
 constraint Book_Publisher_Phone_No check (Phone_No not like '%[^0-9]%')


);

create table Book_Collection
(  
   Book_Id    smallint,
   Book_Name	character varying not null,
   Genre_Id   integer,	
   Author_Id	integer,
   Publisher_Id integer,
   Price_AUD	integer,
   In_Stock integer,
   
   constraint Book_Collectionpk primary key (Book_Id),
   constraint Book_Collectionfk_Book_Genres foreign key (Genre_Id) references Book_Genres on delete cascade,
   constraint Book_Collectionfk_Author_Details foreign key (Author_Id) references Author_Details,
   constraint Book_Collectionfk_Book_Publisher foreign key (Publisher_Id) references Book_Publisher,
   constraint unq_Book_Collection_book_name unique (book_name)
);



create table Employee_Information

(
  
  Employee_Id	smallint,
  Employee_Name character varying(40) not null,
  Position	character varying(40),
  Date_Birth DATE,
  Date_Hire DATE,	
  Address character varying(40),
  Phone_No   varchar(11),
  Extension integer,
  Qualification	 character varying(40),
  Report_to_Manager smallint,
  
  constraint Employee_Informationpk primary key(Employee_Id),
 constraint Employee_Information_Phone_No check (Phone_No not like '%[^0-9]%')
);


create table Contact_Publisher
(
employee_id integer,
publisher_id integer,
constraint Contact_Publisherfk_Employee_Information foreign key (employee_id) references Employee_Information,
constraint Contact_Publisherfk_Book_Publisher foreign key (publisher_id) references Book_Publisher

);


create table Customer_Information
(
Customer_id	integer,
Customer_Name	character varying,
Address	      character varying,
Phone	 varchar(11),
Email  character varying,

 constraint Customer_Informationpk primary key(Customer_Id),
 constraint Customer_Information_Customer_Id check (Customer_Id is not null),
  constraint Customer_Information_Phone check (Phone not like '%[^0-9]%'),
  constraint Customer_Information_Email check (Email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);


create table Purchase_Information
(
Purchase_Id integer,
Book_Id integer,
Price	 integer,
Quantity integer,
Discount  float,
Customer_Id integer,
Employee_Id integer,
Date_Order Date,
Date_Shipped character varying,
Shipping_Address	character varying,

constraint Purchase_Informationpk primary key (Purchase_Id),
constraint Purchase_Informationfk_Book_Collection foreign key (Book_Id) references Book_Collection,
constraint Purchase_Information_Price check (Price > 0),
constraint Book_Purchasefk_Customer_Information foreign key (Customer_Id) references Customer_Information on delete restrict,
constraint Book_Purchasefk_Employee_Information foreign key (Employee_Id) references Employee_Information

);


create view BookinGenres as
  select Genre_Id
  , Genre_name
  , Book_Id
  , Book_name
  , Publisher_Id
  , Price_aud
  , In_stock
from Book_Genres natural join book_collection 
where genre_name  = 'Horror' ;

create view OrderDetails  as
select Purchase_Id 
,Book_Id 
,Price	 
,Quantity 
,Discount 
,Date_Order
,Employee_Id	
,Employee_Name
,Customer_id
,Customer_Name
from Purchase_Information natural join  Customer_Information natural join employee_information 
where price > 15 
order by Date_Order;


insert into Book_Genres values(1,	'Fantasy',	'This book genre is characterized by elements of magic or the supernatural and is often inspired by mythology or folklore');
insert into Book_Genres values(2,	'Science Fiction',	'The job of science nonfiction is not to predict the future, but to make sense of the world we’re currently living in');
insert into Book_Genres values(3,	'Action & Adventure',	'If you’re writing adventure, then chances are your book follows the structure of the Hero’s Journey. Your protagonist has a very important goal to achieve, but they’re really going to have to go through the wringer first');
insert into Book_Genres values(4,	'Mystery',	'Also called detective fiction, this book genre is characterized by a gripping plot that revolves around a mystery');
insert into Book_Genres values(5,	'Horror',	'What unites the books in this genre is not theme, plot, or setting, but the feeling they inspire in the reader: your pulse quickens, and your skin prickles as you turn the page with bated breath');
insert into Book_Genres values(6,	'Thriller & Suspense',	'Thrillers typically include cliffhangers, deception, high emotional stakes, and plenty of action — keeping the reader on the edge of their seat until the book’s climax');
insert into Book_Genres values(7,	'Humor',	'Laugh-out-loud memoirs by the funniest celebs, satirical essays.ll the books in this rib-tickling genre are written with one thing in mind: making readers laugh!');

insert into Author_Details values(1,	'Andrew Parker',	'USA');
insert into Author_Details values(2, 'Matthew Lindsay',	'UK');
insert into Author_Details values(3, 'Stephan Morris',	'UK');
insert into Author_Details values(4, 'Michelle Shepphard',	'USA');
insert into Author_Details values(5,	'Lina Dawson',	'South Africa');
insert into Author_Details values(6,'Peter Parker','USA');
insert into Author_Details values(7, 'Andrew Lindsay',	'UK');
insert into Author_Details values(8,  'Matt Morris',	'UK');
insert into Author_Details values(9,	'Lina Shepphard',	'USA');
insert into Author_Details values(10,	'Michelle Dawson', 'South Africa');
insert into Author_Details values(11,	'Lioni Hyder',	'USA');
insert into Author_Details values(12,	'Prakash Gupta',	'UK');
insert into Author_Details values(13,	'Raj Khatri',	'UK');
insert into Author_Details values(14,	'Jack Lord',	'USA');
insert into Author_Details values(15,	'Ansar Raza',	'South Africa');
insert into Author_Details values(16,	'Angela Marcus',	'USA');
insert into Author_Details values(17,	'Matthew Angus',	'UK');
insert into Author_Details values(18,	'Stephan Morris',	'UK');
insert into Author_Details values(19,	'Dev Verma',	'USA');
insert into Author_Details values(20,	'Yalda Saher',	'South Africa');


insert into Book_Publisher values(1,     'XXX Publication',    'James Smith',    '22 liverpooll Street',   'Liverpool',    'NSW',    'Australia',      1234569820,     'xxx@gmail.com');
insert into Book_Publisher values(2,     'XYX Publication',     'Peter Daniel',  '23 Pittt Street',         'Redfern',     'NSW',     'Australia',      1238569850,   'xyx@gmail.com');
insert into Book_Publisher values(3,     'YYX Publication',     'Nathan Kon',    '43 James Street',         'Melbourn',    'Vic',     'Australia',      1236874202,    'yyx@gmail.com');
insert into Book_Publisher values(4,     'YYZ publication',     'Jayden Lion',   '77 Taylor Street',        'Brisbane',    'QLD',     'Australia',      1234569871,    'yyz@gmail.com');
insert  into Book_Publisher values(5,     'ZZZ Publication',     'Tom Hilton',    '55 Deli Road',            'Perth',        'WA',     'Australia',      1265789667,     'zzz@gmail.com');



insert into Book_Collection values(1, 'Dream Diaries1',	1,	5,	4,	15,	30);
insert into Book_Collection values(2,	'Horror Stories1', 5,	3,	3,	25,	35);
insert into Book_Collection values(3,	'Tomorrow Never Seen', 3,	1,	2,	30,	55);
insert into Book_Collection values(4,	'Never Ending Journey',	4,	4,	5,	25,	40);
insert into Book_Collection values(5,	'A Dark Night',	6,	2,	1,	17,	25);
insert into Book_Collection values(6,	'Laughter Challenge',7,	6,	5,	19,	44);
insert into Book_Collection values(7,	'Above The Sky',	2,	7,	4,	27,	55);
insert into Book_Collection values(8,	'Dream Diaries2',	1,	8,	2,	20,	43);
insert into Book_Collection values(9,	'Forest can speak',	5,	9,	3,	26,	17);
insert into Book_Collection values(10, 'A Fight in the Down Town',	3,	10,	1,	16,	80);
insert into Book_Collection values(11,	'A Mistorious Night',	4,	11,	1,	28,	90);
insert into Book_Collection values(12,	'Mr. James',	6,	15,	4,	18.5,	0);
insert into Book_Collection values(13,	'Laughter In The Club',	7,	14,	5,	17.5,	10);
insert into Book_Collection values(14,	'In The Water',	2,	13,	3,	30.25,	0);
insert into Book_Collection values(15,	'Horror Stories2', 5,	12,	2,	38.4,	33);
insert into Book_Collection values(16,	'Dream Diaries3',	1,	19,	4,	33.5,	77);
insert into Book_Collection values(17,	'A Boy In The Town',	4,	20,	3,	19.8,	13);
insert into Book_Collection values(18,	'A Dark Room',	5,	18,	2,	25.99,	58);
insert into Book_Collection values(19,	'A Boat At The Shores',	6,	17,	5,	16.66,	67);
insert into Book_Collection values(20,	'Tomorrow Never Seen2',	3,	16,	1,	20.25,	39);

insert into Employee_Information values(1,	    'Andrew Peterson',	'Sales Representative','1990-01-12','2018-02-03','42 Mac Street Stratfield NSW 2196',	      1231231231,	231,	'B.A',	4);
insert into Employee_Information values(2,	    'Janet Jacson',  	'Vice President Sales',	    '1972-03-15',	  '2010-03-19',	  '110 Peter Street Paramatta NSW 2198',      1231231232,	232,	'M.A', Null);
insert into Employee_Information values(3,	    'Margaret Pariera',	'Sales Representative',	    '1985-05-27',   '2017-05-22',	  '220 Deli Street Hornsby NSW 2198',	      1231231233,	233,	'B.A',	4);
insert into Employee_Information values(4,	    'Steven Smith',	    'Sales Manager',	        '1981-05-01',	  '2021-05-18',     '4/12 Rffy Street St. Peters NSW 8520',     1231231234,	234,	'M.A',	2);
insert into Employee_Information values(5,	    'Michael Schemidt',	'Inside Sales Coordinator',	'1987-08-09',	  '2020-09-09',     '13 Jefry Street Marickville NSW 2580',     1231231235,	235,	'C.A',	2);
insert into Employee_Information values(6,	    'Robert Butler',	'Sales Representative',	    '1984-11-12',	  '2011-12-11',	  '67 Eddy Avenue Campsie NSW  2146',	      1231231236,	236,	'B.A',  4);
insert into Employee_Information values(7,	    'Laura Davidson',	'Sales Representative',	    '1981-11-07',	  '2018-07-11',	  '89 Maxwill Road Lakeview NSW 2177',        1231231237,	237,	'B.A',	4);
insert into Employee_Information values(8,	    'Anne Fernandiz',	'Sales Representative',   	'1978-06-04',   '2016-04-06',	  '255 James Street Milson Point NSW 2155',	  1231231238,	238,	'Diploma_in_Customer Service',	4);
insert into Employee_Information values(9,	    'Nancy Jacob',      'Sales Representative',	    '1983-07-25',	 '2016-08-09',	  '880 Pointcreek Road Cambeltown NSW 2100',  1231231239,   239,	'Diploma_in_Customer Service',	4);


insert into Contact_Publisher values(1,	5);
insert into Contact_Publisher values(3,	4);
insert into Contact_Publisher values(6,	2);
insert into Contact_Publisher values(7, 3);
insert into Contact_Publisher values(8, 1);
insert into Contact_Publisher values(9, 5);



      
insert into Customer_Information values(1,	'Yasir Malik',	   '22 Davis Street Pandara NSW 8761 Australia',	          043412345,	'xxxxx12345@gmail.com');
insert into Customer_Information values(2,	'Ankit Tiwari',	   '21 Taylor Street Martin Place NSW 8614 Australia',	      043123456,	'xxxxx23456@gmail.com');
insert into Customer_Information values(3,	'Peter James',	   '99 Tweek Place Sutherland NSW 2256 Australia',	          043344567,	'xxxxx34567@gmail.com');
insert into Customer_Information values(4,	'Ram Parsad',	   '108 Elizabeth Street Campsie NSW 8145 Australia',	      043445678,	'xxxxx45678@gmail.com');
insert into Customer_Information values(5,	'Saba Khan',	   '44 Cross Road Kempsy NSW 2266 Australia',	              044556789,	'xxxxx56789@gmail.com');
insert into Customer_Information values(6,	'Tom Micky',	   '88 Lindsay Ckt Liverpool NSW 2899 Australia',	          043567891,	'xxxxx67891@gmail.com');
insert into Customer_Information values(7,	'Travis Hockings', '91 Liverpool Road Liverpool NSW 2899 Australia',	      046567892,	'xxxxx67892@gmail.com');
insert into Customer_Information values(8,	'Matt Dallas',	   '44 Oxford Street Paddington NSW 2241 Australia',	      045667894,	'xxxxx67894@gmail.com');
insert into Customer_Information values(9,	'Michelle Myilone','55 Pitt Street Marickville NSW 4256 Australia',	          045667895,	'xxxxx67895@gmail.com');
insert into Customer_Information values(10,	'Daniel Morris',   '88 Sussex Street New Castle NSW 8891 Australia',	      046767896,	'xxxxx67896@gmail.com');
insert into Customer_Information values(11,	'Natasha Lue',	   '41 River Rood Brisbane QLD 3356 Australia',	              047867897,	'xxxxx67897@gmail.com');
insert into Customer_Information values(12,	'Martin Lee',	   '22 Dales Ckt Perth 2654 Australia',	                      047867898,	'xxxxx67898@gmail.com');
insert into Customer_Information values(13,	'Hong Hu',	       '2102 Mortdale Road QLD 3350 Australia',	                  046767899,	'xxxxx67899@gmail.com');
insert into Customer_Information values(14,	'Jack Danham',	   '2111 Morris Street New Castle 8891 Australia',	          048778921,	'xxxxx78921@gmail.com');
insert into Customer_Information values(15,	'Louise Dilbareni','41 Tweed head Road Tweed head NSW 2288 Australia',	      044578922,	'xxxxx78922@gmail.com');
insert into Customer_Information values(16,	'Shasha Tez',	   '101 Chappal Road Bankstown NSW 2240 Australia',	          047878923,	'xxxxx78923@gmail.com');
insert into Customer_Information values(17,	'Rita Devi',	   '442 Doon Side Road Millyfields Brisbane QLD 3348 Australia',	042378924,	'xxxxx78924@gmail.com');
insert into Customer_Information values(18,	'Zahida Begum',	   '841 Lakeview Ct Riversdale Perth WA2630 Australia',	      048778925,	'xxxxx78925@gmail.com');
insert into Customer_Information values(19,	'Charles Alberto',	'99 Newton Road Newtown Melbourne Vic 3333 Australia',	  048778926,	'xxxxx78926@gmail.com');
insert into Customer_Information values(20,	'Tania Fernandiz',	'14 Martin Place Hiberfields Brisbane QLD 3330 Australia',046778927,	'xxxxx78927@gmail.com');
insert into Customer_Information values(21,	'Robie Singh',	   '501 Hilly Creek Road Melbourne Vic  3325 Australia',	  087578928,	'xxxxx78928@gmail.com');
insert into Customer_Information values(22,	'David Smith',     '2 Elizabeth Street Melbourne Vic 3320 Australia',	      047778929,	'xxxxx78929@gmail.com');
insert into Customer_Information values(23,	'Jack Daniel',     '56 Bwerora Heights Hornsby NSW 2280 Australia',	          049878930,	'xxxxx78930@gmail.com');
insert into Customer_Information values(24, 'Mairam Naaz',	'33 Lisa Ct Brisbane QLD 3480 Australia',                     046878931,	'xxxxx78931@gmail.com');


insert into Purchase_Information values(123,	1,	15 ,	14,	0.16, 2,	8,	'2021-07-08',	  '2021-07-09',	'56 Mark Street Melbourn Vic 3156 Australia');
insert into Purchase_Information values(124,	2,	25,	    15,	0.12,3,	7,	'2021-07-08',	  '2021-07-09',	'88 Ocean Drive Perth WA 8123 Australia');
insert into Purchase_Information values(125,	3,	30,  	10,	0.13,4,	6,	'2021-07-09',	  '2021-07-11',	'99 Ocean Street OceanVille QLD 4478 Australia');
insert into Purchase_Information values(126,	4,	25,  	11,	0.15,5,	3,	'2021-07-10',	  '2021-07-13',	'44 XYZ Street XYZVille QLD 4477 Australia');
insert into Purchase_Information values(127,	5,	17,	    6,	0.18,6,	1,	'2021-07-11',	  '2021-07-15',	'102 Oxford Street Paddington NSW 2141 Australia');
insert into Purchase_Information values(128,	6,	19,	    25,	0.15,7,	9,	'2021-07-12',	  '2021-07-14',   '221 Pitt Street Melbourn Vic 3125 Australia');
insert into Purchase_Information values(129,	7,	27,	    13,	0.11,8,	8,	'2021-07-15',	  '2021-07-17',	'441 King Street Cabramatta NSW 2156 Australia');
insert into Purchase_Information values(130,	8,	20,  	17,	0.11,9,	7,	'2021-07-16',	  '2021-07-19',	'451 Sussex Street Melbourn Vic 3141 Australia');
insert into Purchase_Information values(131,	9,	26,	    20,	0.16,10,	6,	'2021-07-17',	  '2021-07-21',	'33 Gold Street Sydney NSW 2144 Australia');
insert into Purchase_Information values(132,	10,	16,	    12,	0.20,11,	3,	'2021-07-18',	  '2021-07-21',	'880 Victoria Street Cambeltown NSW 2177 Australia');
insert into Purchase_Information values(133,	11,	28,  	11,	0.16,1,	9,	'2021-07-05',	  '2021-07-07',	'55 Matthew Street Marickville NSW 2156 Australia');
insert into Purchase_Information values(134,	13,	17.5,	13,	0.18,12,	1,	'2021-07-19',	  '2021-07-21',   '789 Melbourn Street Brisbane  QLD 4471 Australia');
insert into Purchase_Information values(135,	14,	30.25,	10,	0.19,13,	9,	'2021-07-19',	  '2021-07-21',	'889 Brisbane Street Melbourn VIC 3140 Australia');
insert into Purchase_Information values(136,	15,	38.4,	11,	0.05,14,	8,	'2021-07-22',	  '2021-07-25',	'954 Royal Street Belmore NSW 2114 Australia');
insert into Purchase_Information values(137,	16,	33.5,	12,	0.06,15,	7,	'2021-07-23',	  '2021-07-25',	'444 Daily Road Kempsy NSW 2155 Australia');
insert into Purchase_Information values(138,	17,	19.8,	8,	0.07,16,	6,	'2021-07-24',	  '2021-07-25',	'1110 James Street New Castle NSW 2199 Australia');
insert into Purchase_Information values(139,	18,	25.99,	9,	0.12,17,	3,	'2021-07-25',	  '2021-07-27',   '21 Charles Street Perth WA 8122 Australia');
insert into Purchase_Information values(140,	19,	16.66,	6,	0.02,18,	1,	'2021-07-26',	  '2021-07-27',	'345 Madam Street Paramatta NSW 2122 Australia');
insert into Purchase_Information values(141,	20,	20.25,	13,	0.03,19,	8,	'2021-07-29',   '2021-08-01',	'85 ZigZack Street ZickZack NSW 2197 Australia');
insert into Purchase_Information values(142,	1,	15, 	11,	0.11,20,	8,	'2022-07-30',	  '2022-08-01',	'2145 Jazz Street Brisbane Qld 4417 Australia');
insert into Purchase_Information values(143,	2,	25, 	19,	0.30,21,	1,	'2022-07-31',	  '2022-08-01',	'2124 Silver Water Road Silver Waters NSW 2111 Australia');
insert into Purchase_Information values(144,	3,	30,     18,	0.20,22,	9,	'2022-08-01',	  '2022-08-03',	'8145 Elizabeth Street Manly NSW 2113 Australia');
insert into Purchase_Information values(145,	4,	25,     19,	0.09,23,	8,	'2022-08-01',   '2022-08-03',	'2521 TimTam Street TimTam NSW 2110 Australia');
insert into Purchase_Information values(146,	5,	17, 	12,	0.19,24,	7,	'2022-08-02',	  '2022-08-03',	'85 The mall Melbourn Vic 3114 Austrlia');