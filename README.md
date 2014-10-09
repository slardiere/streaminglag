# Streaming Lag Extension

This extension provide useful functions to compute `Log Sequence Number` and
show


These functions translate `LSN` in `bigint` : 

- create or replace function CalculateNumericalOffset(text) returns bigint
- create or replace function CalculateNumericalOffset(pg_lsn) returns bigint

These functions calculate difference between `LSN` :

- create or replace function pg_streaming_lag( text, text ) returns bigint
- create or replace function pg_streaming_lag( pg_lsn, pg_lsn ) returns bigint

Before PostgreSQL 9.4, `LSN` data are stored as `text`

These function can be used with the view `pg_stat_replication`, as shown in the
following queries :

	select pid, backend_start, sync_state,
	  pg_size_pretty(pg_streaming_lag(sent_location,write_location)) as write_lag,
	  pg_size_pretty(pg_streaming_lag(sent_location,flush_location)) as flush_lag,
	  pg_size_pretty(pg_streaming_lag(sent_location,replay_location) ) as replay_lag
	from pg_stat_replication ;

Differents Lags are calculate from `sent_location` on the master to `write`, `flush`
 and `replay` on a standby. 

