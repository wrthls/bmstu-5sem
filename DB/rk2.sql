-- var 2
-- Маковская Яна ИУ7-54Б

create database rk2;

create table privivka (
    pr_id int primary key,
    pr_name varchar(30),
    pr_des varchar(30)
);

create table child (
    c_id int primary key,
    c_name varchar(30),
    c_surname varchar(30),
    c_birth int,
    c_adr varchar(30),
    c_tel varchar(30)
);

create table poliklinika (
    pol_id int primary key,
    pol_year varchar(4),
    pol_des varchar(30)
);

create table p_pr (
    p_pr_id int primary key not null identity(1, 1),
    pr_id int,
    constraint pr_id foreign key(pr_id) references privivka(pr_id),
    pol_id int,
    constraint pol_id foreign key(pol_id) references poliklinika(pol_id)
);

create table pr_c (
    pr_c_id int primary key not null identity(1, 1),
    pr_id int,
    constraint pr_id_1 foreign key(pr_id) references privivka(pr_id),
    c_id int,
    constraint c_id foreign key(c_id) references child(c_id)
);
 
insert into child(c_id, c_name, c_surname, c_birth, c_adr, c_tel) 
values ('1', 'Anna', 'Petrova', 2005, 'Moscow', '89670647468'),
('2', 'Ivan', 'Ivanov', 2009, 'Moscow', '89456647468'),
('3', 'Petr', 'Sidorov', 2011, 'Omsk', '89670642648'),
('4', 'Alina', 'Popova', 2015, 'Biysk', '89345677468'),
('5', 'Oleg', 'Ivanov', 2007, 'Moscow', '89624573859');

insert into poliklinika(pol_id,pol_year,pol_des) 
values ('1', '1934', 'children'),
('2', '1932', 'adult'),
('3', '1925', 'children'),
('4', '1967', 'adult'),
('5', '2001', 'children');

insert into privivka(pr_id, pr_name, pr_des) 
values ('1', 'N23', ' grip'),
('2', 'A75', 'venryanka'),
('3', 'R34', 'gipatit'),
('4', 'Q34', 'stolbnyak'),
('5', 'Y76', 'ptichiy grip');

insert into p_pr(pr_id, pol_id)
VALUES (1, 2),
(2, 4),
(3, 1),
(4, 5),
(5, 3);

insert into pr_c(pr_id, c_id)
VALUES (5, 2),
(4, 4),
(3, 1),
(2, 5),
(1, 3);

SELECT * from child;
SELECT * from poliklinika;
SELECT * from privivka;
SELECT * from p_pr;
SELECT * from pr_c;

-- Инструкция, использующая предикат сравнения
-- Выводит поликлиники, которые были открыты до 1998 года
select * 
from poliklinika
where pol_year < 1998
order by(pol_year);

-- Инструкция, использующая оконную функцию
-- дает уникальный айди повторяющимся фамилиям 
select c_id, c_name, c_surname,
ROW_NUMBER() over (PARTITION by c_surname order by c_id) as Uniq_surname
from child;

-- Вложенный корелированный подзапрос в from
-- вывод информации о детях, привитых от столбняка
select child.c_id, c_name, c_surname, tmp.pr_id, pr_des
    from (child join
    (select c_id, pr_id
        from pr_c 
        where pr_id = 4) as tmp
    on child.c_id = tmp.c_id)
join privivka on privivka.pr_id = tmp.pr_id;
GO

-- ограничение на описание поликлиники
alter table poliklinika add
constraint check_pol
check(pol_des like 'children' or pol_des like 'adult');
GO

-- Процедура
-- выводит имена ограничений CHECK и выражения SQL, которыми определяются данные исключения,
-- в тексте которых встречается предикат
create procedure get_constraints(@bd varchar(30)) as 
begin
	select constraint_name, check_clause 
    from information_schema.check_constraints
    where constraint_catalog = @bd 
    and check_clause like '%like%';
end;

exec get_constraints 'rk2';
