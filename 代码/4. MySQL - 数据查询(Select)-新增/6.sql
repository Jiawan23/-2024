-- 6) 查找相似的理财客户
--   请用一条SQL语句实现该查询：

select *
from
	(select t1.pro_c_id pac,t2.pro_c_id pbc,count(*) as common,
		rank()over(partition by t1.pro_c_id order by count(*) desc,t2.pro_c_id) crank
	from property t1, property t2
	where t1.pro_type=1 and t2.pro_type=1 and t1.pro_c_id != t2.pro_c_id
		and t2.pro_pif_id = t1.pro_pif_id
	group by pac,pbc
	order by pac) t
where crank  < 3
order by pac,crank

/*  end  of  your code  */