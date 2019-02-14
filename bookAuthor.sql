drop table if exists book cascade;
drop table if exists author cascade;
drop table if exists bookauthor cascade;

create table book (
    Title TEXT,
    Edition Int,
    Publisher TEXT,
    ISBN BigInt primary key
);

create table author (
	ID int primary key not null,
    Name TEXT 
);

create table bookauthor (
    authorid int,
    bookisbn BigInt,
    
    -- author primary key referenced to make foreign key
	constraint BA_FK1 foreign key (authorid) references author(ID),
    -- book primary key referenced to make foreign key
    constraint BA_FK2 foreign key (bookisbn) references book(ISBN),
    -- Composite Key: Created with the two foreign keys
    constraint BA_PK primary key (authorid,bookisbn)
);

-- Populating book Table
insert into book values ('Object-Oriented Design and Patterns', 2, 'Wiley', 9780471744870);
insert into book values ('Intro to Java Programming, Comprehensive Version', 10, 'Pearson', 9780133761313);
insert into book values ('Advanced Engineering Mathematics', 10, 'Wiley', 9780470458365);
insert into book values ('Computer Architecture', 5, 'Elsevier Science',9780123838728);

-- Populating author Table
insert into author values (1, 'Cay S. Horstmann');
insert into author values (2, 'Y. Daniel Liang');
insert into author values (3, 'Erwin O. Kreyszig');
insert into author values (4, 'John L. Hennessy');
insert into author values (5, 'David A. Patterson');

-- Populating bookauthor Table
insert into bookauthor values (1, 9780471744870);
insert into bookauthor values (2, 9780133761313);
insert into bookauthor values (3, 9780470458365);
insert into bookauthor values (4, 9780123838728);
insert into bookauthor values (5, 9780123838728);
