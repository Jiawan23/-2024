use finance1;
drop trigger if exists before_property_inserted;
-- 请在适当的地方补充代码，完成任务要求：
delimiter $$
/*before插入前触发做检查*/
create trigger before_property_inserted before insert on property
for each row 
begin
declare msg varchar(50); /*注意要先声明变量*/
/*做合法和存在性检查，用signal sqlstate抛出异常并设置错误信息*/
if new.pro_type = 1 and not exists (select * from finances_product where p_id = new.pro_pif_id) then
    set msg = concat("finances product #", new.pro_pif_id, " not found!");
    signal sqlstate '45000' set message_text = msg;/*45000指用户定义的待处理异常*/
elseif new.pro_type = 2 and not exists (select * from insurance where i_id = new.pro_pif_id) then
    set msg = concat("insurance #", new.pro_pif_id, " not found!");
    signal sqlstate '45000' set message_text = msg;
elseif new.pro_type = 3 and not exists (SELECT * FROM fund WHERE f_id = new.pro_pif_id) then
    set msg = concat("fund #", new.pro_pif_id, " not found!");
    signal sqlstate '45000' set message_text = msg;
elseif new.pro_type not in (1,2,3) then
    set msg = concat("type ", new.pro_type, " is illegal!");
    signal sqlstate '45000' set message_text = msg;
end if;
end$$
delimiter ;
