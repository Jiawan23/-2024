-- 5) 查询任意两个客户的相同理财产品数
--   请用一条SQL语句实现该查询：

select t1.pro_c_id, t2.pro_c_id, count(*) as total_count
from property t1,property t2
where t1.pro_type=1 and t2.pro_type=1 and t1.pro_c_id != t2.pro_c_id
	and t1.pro_pif_id = t2.pro_pif_id
group by t1.pro_c_id,t2.pro_c_id
having total_count >=2
order by t1.pro_c_id

/*  end  of  your code  */