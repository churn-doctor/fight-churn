with observation_params as
(
    select  interval '%metric_interval' as metric_period,
    '%from_yyyy-mm-dd'::timestamp as obs_start,
    '%to_yyyy-mm-dd'::timestamp as obs_end
)
select m.account_id, o.observation_date, is_churn,
sum(case when metric_name_id=0 then metric_value else 0 end) as like_per_month,
sum(case when metric_name_id=1 then metric_value else 0 end) as newfriend_per_month,
sum(case when metric_name_id=2 then metric_value else 0 end) as post_per_month,
sum(case when metric_name_id=3 then metric_value else 0 end) as adview_per_month,
sum(case when metric_name_id=4 then metric_value else 0 end) as dislike_per_month,
sum(case when metric_name_id=27 then metric_value else 0 end) as unfriend_per_month,
sum(case when metric_name_id=6 then metric_value else 0 end) as message_per_month,
sum(case when metric_name_id=7 then metric_value else 0 end) as reply_per_month,
sum(case when metric_name_id=8 then metric_value else 0 end) as account_tenure,
sum(case when metric_name_id=21 then metric_value else 0 end) as adview_per_post,
sum(case when metric_name_id=23 then metric_value else 0 end) as dislike_pcnt,
sum(case when metric_name_id=24 then metric_value else 0 end) as newfriend_pcnt_chng,
sum(case when metric_name_id=25 then metric_value else 0 end) as days_since_newfriend
from metric m inner join observation_params
on metric_time between obs_start and obs_end
inner join observation o on m.account_id = o.account_id
    and m.metric_time > (o.observation_date - metric_period)::timestamp
    and m.metric_time <= o.observation_date::timestamp
group by m.account_id, metric_time, observation_date, is_churn
order by m.account_id,observation_date
