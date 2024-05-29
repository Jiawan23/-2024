-- 2) 投资积极且偏好理财类产品的客户
--   请用一条SQL语句实现该查询：
select distinct pro_c_id
from 
	(select pro_c_id,
		count(pro_type=1 or null) p_num,
        count(pro_type=3 or null) f_num
	from property
    group by pro_c_id
    having p_num>=3 and f_num<p_num) t
order by pro_c_id;

/*  end  of  your code  */