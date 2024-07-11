-- 4) 	查找相似的理财产品

--   请用一条SQL语句实现该查询：
select t3.pro_pif_id, cc,
	dense_rank()over(order by cc desc) as prank
from
	(select pro_pif_id, count(*) as cc
	from property
	where pro_type=1
	group by pro_pif_id) t3,
    
    (select pro_pif_id
	from property
	where pro_type=1 and pro_pif_id != 14 and pro_c_id in
		(select pro_c_id
		from
			(select pro_c_id,count(*) as num,
				dense_rank() over(order by count(*) desc) as rk
			from property
			where pro_type=1 and pro_pif_id=14
			group by pro_c_id) t1
		where rk <=3)
	) t2
where t3.pro_pif_id = t2.pro_pif_id
order by cc desc, pro_pif_id






/*  end  of  your code  */