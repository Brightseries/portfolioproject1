select*
from dbo.orders$

select [Order Date],[Order ID],Sales,[Ship Mode],profit,[Ship Date]
from dbo.orders$

select orderdateconverted,convert(Date,[Order Date])AS order_date
from dbo.orders$

Update orders$
Set [Order Date]=convert(Date,[Order Date])

Alter Table orders$
Add orderdateconverted Date;

Update orders$
Set orderdateconverted=convert(Date,[Order Date])


Select [Order ID],sum(Sales),max(profit)
From dbo.orders$
--Where [Product Base Margin] is null
group by [Order ID]
order by  [Order ID]desc


select convert(Date,[Order Date])AS order_date,max(Sales) as highest_sales 
from dbo.orders$
Group By convert(Date,[Order Date])
Order By highest_sales Desc

select [Order ID],[Ship Mode],Region, sum(Sales-profit)as lose,sum(Sales),sum(profit)
from dbo.orders$
Group by  [Order ID],[Ship Mode],Region


select  distinct Region,Sales, Profit
from dbo.orders$
Order by Sales

select [Ship Mode],[Product Name]
from dbo.Orders$

Select  Distinct [Order ID],[Ship Mode], [Product Name],sum(Sales) as sumofsales,sum(profit) as sumofprofit
From dbo.orders$
--Where [Product Base Margin] is null
group by [Order ID],[Ship Mode],[Product Name]
order by  [Order ID]desc


select a.[Row ID],a.[Order ID],a.Sales*100,a.profit*100,b.[Row ID],b.[Order ID],b.Sales*100,b.profit*100
from dbo.orders$ a
join dbo.orders$ b
   on a.[Order ID] = b.[Order ID]
   and a.[Row ID] <> b.[Row ID]