-- 1) 查询销售总额前三的理财产品
--   请用一条SQL语句实现该查询：
select *
from
	(select pyear,
		rank() over(partition by pyear order by sumamount desc) rk,
		p_id,sumamount
	from
		(select year(pro_purchase_time) as pyear, p_id, sum(pro_quantity*p_amount) as sumamount
		from property,finances_product
		where pro_pif_id = p_id and pro_type=1
		group by pyear, p_id
		having pyear in (2010,2011)) t1
	)t2
where rk<=3;
/*  end  of  your code  */