-- 编写一存储过程，自动安排某个连续期间的大夜班的值班表:

delimiter $$
create procedure sp_night_shift_arrange(in start_date date, in end_date date)
begin
declare done, waitdir int default false; /*done标记游标遍历完毕，waitdir标记是否调班*/
declare nowdate date;
declare waitdr, doctor,nurse1,nurse2 char(30);/*waitder表示调班的主任*/
declare type int;

declare drlist cursor for select e_name,e_type from employee where e_type < 3;
declare nrlist cursor for select e_name from employee where e_type = 3;
declare continue handler for not found set done = true;

open drlist;open nrlist;

set nowdate = start_date;
while nowdate <= end_date do
    /*安排医生*/
    if weekday(nowdate) < 5 and waitdir then/*主任夜班调至周一*/
        set doctor = waitdr, waitdir = false;
    else
        fetch drlist into doctor, type;
        if done then 
        -- 每次遍历完成一遍后done为true 需要重启表格重新开始遍历
            close drlist;open drlist;
            fetch drlist into doctor, type;
            set done = false;
        end if;
        if weekday(nowdate) >= 5 and type = 1 then/*主任遇到周末*/
            set waitdir = true, waitdr = doctor;
            fetch drlist into doctor, type;/*后面的医生递补*/
            if done then
                close drlist;open drlist;
                fetch drlist into doctor, type;
                set done = false;
            end if;
        end if;
    end if;
    /*安排第一名护士*/
    fetch nrlist  into nurse1;
    if done then
        close nrlist;open nrlist;
        fetch nrlist into nurse1;
        set done = false;
    end if;
    /*安排第二名护士*/
    fetch nrlist into nurse2;
    if done then
        close nrlist;open nrlist;
        fetch nrlist into nurse2;
        set done = false;
    end if;
    /*插入排班结果*/
    insert into night_shift_schedule values (nowdate, doctor, nurse1, nurse2);
    set nowdate = date_add(nowdate, interval 1 day);/*日期递增一天*/
end while;
end$$
delimiter ;
/*  end  of  your code  */ 
