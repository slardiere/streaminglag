-- Calculate From : http://munin-monitoring.org/browser/munin/plugins/node.d/postgres_streaming_.in
-- with help : http://www.postgresql.org/docs/9.3/static/monitoring-stats.html#PG-STAT-REPLICATION-VIEW
-- http://eulerto.blogspot.fr/2011/11/understanding-wal-nomenclature.html

create or replace function CalculateNumericalOffset(text)
returns bigint
language sql
as $$
select ('x'||lpad( 'ff000000', 16, '0'))::bit(64)::bigint
* ('x'||lpad( split_part( $1 ,'/',1), 16, '0'))::bit(64)::bigint
+ ('x'||lpad( split_part( $1 ,'/',2), 16, '0'))::bit(64)::bigint ;
$$
;

create or replace function CalculateNumericalOffset(pg_lsn)
returns bigint
language sql
as $$
select ('x'||lpad( 'ff000000', 16, '0'))::bit(64)::bigint
* ('x'||lpad( split_part( $1::text ,'/',1), 16, '0'))::bit(64)::bigint
+ ('x'||lpad( split_part( $1::text ,'/',2), 16, '0'))::bit(64)::bigint ;
$$
;


create or replace function pg_streaming_lag( text, text )
returns bigint
language sql
as $$
select CalculateNumericalOffset( $1 ) - CalculateNumericalOffset( $2 ) ;
$$
;

create or replace function pg_streaming_lag( pg_lsn, pg_lsn )
returns bigint
language sql
as $$
select CalculateNumericalOffset( $1 ) - CalculateNumericalOffset( $2 ) ;
$$
;
