-- Insurance Analysis Project --
use project;
show tables;


select * from brokerage;
select * from fees;
select * from individual_budgets;
select * from invoice;
select * from meeting;
select * from opportunity;

-- 1.No of Invoice by Account Exec --
select count(income_class), Account_Executive, income_class from invoice group by Account_Executive, income_class;

-- 2.yearly meeting count --
select year(meeting_date) as year, count(global_attendees) from meeting group by year;

-- 4.Stage Funnel by Revenue --
select stage, sum(revenue_amount) from opportunity group by stage;

-- 5.No of meeting By Account Exe --
select account_executive, count(global_attendees) as meeting_count from meeting group by account_executive;

-- 6.Oppty-Product Distribution --
select product_group, count(opportunity_id) from opportunity group by product_group;

-- Oppty by Revenue-top 10 --
select opportunity_name, sum(revenue_amount) as amount from opportunity group by opportunity_name order by amount desc limit 10;

-- opportunity difference --
select stage, count(stage), case
when stage="qualify opportunity" or "propose solution" then "open"
when stage="negotiate" then "closed won"
else "open"
end as oppty_type from opportunity group by stage;

-- total opportunity --
select count(stage) as total_oppty from opportunity;

-- open opportunity --
create view open_oppty as select count(stage) as open_oppty from opportunity where stage in ("qualify opportunity", "propose solution");
select * from open_oppty;

-- open oppty top 10 --
select distinct Opportunity_name, stage, revenue_amount from opportunity  where stage in ("qualify opportunity", "propose solution") order by revenue_amount desc limit 10;

-- 3.target --
select sum(Cross_sell_budget) as target_cross_sell from individual_budgets; -- cross
select sum(new_budget) as target_new from individual_budgets;  -- neww
select sum(renewal_budget) as target_renewal from individual_budgets; -- renewal

-- Invoiced Achievement --
select sum(amount) from invoice where income_class = "cross sell";
select sum(amount) from invoice where income_class = "new";
select sum(amount) from invoice where income_class = "renewal";

-- cross sell Placed Achievement --
create view cross_sell_plcd_achived as (select(select sum(amount) from brokerage where brokerage.income_class in ("cross sell")) + sum(amount) as achived_amount, 
income_class from fees where income_class in ("cross sell"));
select * from cross_sell_plcd_achived;

-- new plcd achive --
create view new_plcd_achiv as (select(select sum(amount) from brokerage where brokerage.income_class in ("new")) + sum(amount) as achived_amount,
income_class from fees where income_class in ("new"));
select * from new_plcd_achiv;

-- renewal plcd achive --
create view renewal_plcd_achive as (select(select sum(amount) from brokerage where brokerage.income_class in ("renewal")) + sum(amount) as achived_amount,
income_class from fees where income_class in ("renewal"));
select * from renewal_plcd_achive;


-- cross sell plcd achive % --
SELECT CONCAT(ROUND(((SELECT SUM(amount) FROM brokerage WHERE income_class = "cross sell")+(SELECT SUM(amount) FROM fees WHERE income_class = "cross sell"))
/(SELECT SUM(Cross_sell_budget) FROM individual_budgets)* 100, 2),"%") AS "Cross sell plcd Ach %";

-- cross sell invoice achive % --
select concat(round((select sum(amount) from invoice
 where income_class = "Cross sell")/ (select sum(Cross_sell_budget)
 from individual_budgets)*100,2),"%") As "Cross sell invoice Ach %" ;
 
 -- new plcd achiv % --
select concat(round(((select sum(amount) from brokerage where income_class = "new")+
(select sum(amount) from fees where income_class ="new"))/(select sum(new_budget) from individual_budgets)*100, 2),"%") as "new_plcd_achiv_%";


-- new invoice achive % --
select concat(round((select sum(amount) from invoice
 where income_class = "new")/ (select sum(new_budget)
 from individual_budgets)*100,2),'%') As "new invoice Ach %" ;
 
 -- renewal plcd achiv % --
select concat(round(((select sum(amount) from brokerage where income_class = "renewal")+
(select sum(amount) from fees where income_class ="renewal"))/(select sum(renewal_budget) from individual_budgets)*100, 2),"%") as "renewal_plcd_achiv_%";

-- renewal invoice achive % --
select concat(round((select sum(amount) from invoice
 where income_class = "renewal")/ (select sum(renewal_budget)
 from individual_budgets)*100,2),'%') As "renewal invoice Ach %" ;