-- 编写一存储过程，自动安排某个连续期间的大夜班的值班表:

delimiter $$
create procedure sp_night_shift_arrange(in start_date date, in end_date date)
begin
declare done, waitdir int default false;
declare nowdate date;
declare waitdr, doctor,nurse1,nurse2 char(30);
declare type int;

declare drlist cursor for select e_name,e_type from employee where e_type < 3;
declare nrlist cursor for select e_name from employee where e_type = 3;

declare continue handler for not found set done = true;

open drlist;
open nrlist;

set nowdate = start_date;
while nowdate <= end_date do
    if weekday(nowdate) < 5 and waitdir then
        set doctor = waitdr, waitdir = false;
    else
        fetch drlist into doctor, type;
        if done then 
        -- 每次遍历完成后done为true 需要重启表格重新开始遍历
            close drlist;
            open drlist;
            fetch drlist into doctor, type;
            set done = false;
        end if;
        if weekday(nowdate) >= 5 and type = 1 then
            set waitdir = true, waitdr = doctor;
            fetch drlist into doctor, type;
            if done then
                close drlist;
                open drlist;
                fetch drlist into doctor, type;
                set done = false;
            end if;
        end if;
    end if;

    fetch nrlist  into nurse1;
    if done then
        close nrlist;
        open nrlist;
        fetch nrlist into nurse1;
        set done = false;
    end if;

    fetch nrlist into nurse2;
    if done then
        close nrlist;
        open nrlist;
        fetch nrlist into nurse2;
        set done = false;
    end if;

    insert into night_shift_schedule values (nowdate, doctor, nurse1, nurse2);
    set nowdate = date_add(nowdate, interval 1 day);
end while;
end$$

delimiter ;

/*  end  of  your code  */ 
