--Testcase 64:
CREATE EXTENSION pgspider_ext;
--Testcase 65:
CREATE EXTENSION postgres_fdw;
-- Enable to pushdown aggregate
SET enable_partitionwise_aggregate TO on;
-- Turn off leader node participation to avoid duplicate data error when executing
-- parallel query
SET parallel_leader_participation TO off;
--Testcase 66:
CREATE SERVER pgspider_ext_svr FOREIGN DATA WRAPPER pgspider_ext;
--Testcase 67:
CREATE USER MAPPING FOR public SERVER pgspider_ext_svr;
--Testcase 68:
CREATE TABLE test1 (i int,__spd_url text) PARTITION BY LIST (__spd_url);
--Testcase 69:
CREATE TABLE test2 (t text, t2 text, i int,__spd_url text) PARTITION BY LIST (__spd_url);
--- PGSpider 1
--Testcase 70:
CREATE SERVER pgspider_srv_1 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', port '5433', dbname 'postgres');
--Testcase 71:
CREATE USER mapping for public server pgspider_srv_1 OPTIONS(user 'postgres',password 'postgres');
-- pgspider_ext table
--Testcase 72:
CREATE FOREIGN TABLE test1__pgspider_srv_1__test (i int,__spd_url text) SERVER pgspider_srv_1 OPTIONS (table_name 'test1');
CREATE FOREIGN TABLE test1_pgspider_srv_child1 PARTITION OF test1 FOR VALUES IN ('/pgspider_srv_1/') SERVER pgspider_ext_svr OPTIONS(child_name 'test1__pgspider_srv_1__test');
--Testcase 1:
SELECT * FROM test1__pgspider_srv_1__test ORDER BY i, __spd_url;
--Testcase 2:
SELECT * FROM test1 ORDER BY i, __spd_url;
--Testcase 3:
SELECT i FROM test1__pgspider_srv_1__test ORDER BY i;
--Testcase 4:
SELECT __spd_url FROM test1__pgspider_srv_1__test ORDER BY __spd_url;
--Testcase 5:
SELECT i FROM test1 ORDER BY i;
--Testcase 6:
SELECT __spd_url FROM test1 ORDER BY __spd_url;
--
--Testcase 73:
CREATE FOREIGN TABLE test2__pgspider_srv_1__test2 (t text, t2 text, i int,__spd_url text) SERVER pgspider_srv_1 OPTIONS (table_name 'test2');
CREATE FOREIGN TABLE test2_pgspider_srv_child1 PARTITION OF test2 FOR VALUES IN ('/pgspider_srv_1/') SERVER pgspider_ext_svr OPTIONS(child_name 'test2__pgspider_srv_1__test2');
--Testcase 7:
SELECT * FROM test2__pgspider_srv_1__test2 ORDER BY i, t2, __spd_url;
--Testcase 8:
SELECT * FROM test2 ORDER BY i, t, t2, __spd_url;
--Testcase 9:
SELECT i, t, t2 FROM test2__pgspider_srv_1__test2 ORDER BY i, t2;
--Testcase 10:
SELECT __spd_url FROM test2__pgspider_srv_1__test2 ORDER BY __spd_url;
--Testcase 11:
SELECT i, t, t2 FROM test2 ORDER BY i, t2;
--Testcase 12:
SELECT __spd_url FROM test2 ORDER BY __spd_url;
-- PGSpider Extension does not support SELECT IN
-- -- SELECT IN
-- --Testcase 13:
-- SELECT * FROM test1 IN ('/pgspider_srv_1pgspider_srv_2/') ORDER BY i;
-- --Testcase 14:
-- SELECT * FROM test1 IN ('/pgspider_srv_1pgspider_srv_2/') WHERE i<>0 ORDER BY i;
-- --Testcase 15:
-- SELECT * FROM test2 IN ('/pgspider_srv_2pgspider_srv_1/') ORDER BY i;
-- --Testcase 16:
-- SELECT * FROM test2 IN ('/pgspider_srv_2pgspider_srv_1/') WHERE i<>500 ORDER BY __spd_url;
-- --Testcase 17:
-- SELECT * FROM test1 IN ('/pgspider_srv_1/sqlite_svr/') ORDER BY i;
-- Currently, __spd_url of PGSpider Extension only show the partition key of the top layer.
-- Therefore, test cases which has WHERE condition with __spd_url for multi-layer will return 0 rows.
-- This point might be improved in the future.
--Testcase 18:
SELECT * FROM test1 WHERE __spd_url = '/pgspider_srv_1/sqlite_svr/' ORDER BY i;
-- --Testcase 19:
-- SELECT * FROM test1 IN ('/pgspider_srv_1/mysql_svr/') ORDER BY i;
--Testcase 20:
SELECT * FROM test1 WHERE __spd_url = '/pgspider_srv_1/mysql_svr/' ORDER BY i;
-- --Testcase 21:
-- SELECT * FROM test1 IN ('/pgspider_srv_1/post_svr/') ORDER BY i;
--Testcase 22:
SELECT * FROM test1 WHERE __spd_url = '/pgspider_srv_1/post_svr/' ORDER BY i;
--
-- --Testcase 23:
-- SELECT * FROM test2 IN ('/pgspider_srv_1/mysql_svr/') ORDER BY i, t, t2, __spd_url;
--Testcase 24:
SELECT * FROM test2 WHERE __spd_url = '/pgspider_srv_1/mysql_svr/' ORDER BY i, t, t2, __spd_url;
--- PGSpider 2
--Testcase 74:
CREATE SERVER pgspider_srv_2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', port '5434', dbname 'postgres');
--Testcase 75:
CREATE USER mapping for public server pgspider_srv_2 OPTIONS(user 'postgres',password 'postgres');
-- pgspider_core_fdw table
--Testcase 76:
CREATE FOREIGN TABLE test1__pgspider_srv_2__test (i int,__spd_url text) SERVER pgspider_srv_2 OPTIONS (table_name 'test1');
CREATE FOREIGN TABLE test1_pgspider_srv_child2 PARTITION OF test1 FOR VALUES IN ('/pgspider_srv_2/') SERVER pgspider_ext_svr OPTIONS(child_name 'test1__pgspider_srv_2__test');
--Testcase 25:
SELECT * FROM test1__pgspider_srv_2__test ORDER BY i, __spd_url;
--Testcase 26:
SELECT * FROM test1 ORDER BY i, __spd_url;
--Testcase 27:
SELECT i FROM test1__pgspider_srv_2__test ORDER BY i;
--Testcase 28:
SELECT __spd_url FROM test1__pgspider_srv_2__test ORDER BY __spd_url;
--Testcase 29:
SELECT i FROM test1 ORDER BY i;
--Testcase 30:
SELECT __spd_url FROM test1 ORDER BY __spd_url;
--
--Testcase 77:
CREATE FOREIGN TABLE test2__pgspider_srv_2__test2 (t text,t2 text,i int,__spd_url text) SERVER pgspider_srv_2 OPTIONS (table_name 'test2');
CREATE FOREIGN TABLE test2_pgspider_srv_child2 PARTITION OF test2 FOR VALUES IN ('/pgspider_srv_2/') SERVER pgspider_ext_svr OPTIONS(child_name 'test2__pgspider_srv_2__test2');
--Testcase 31:
SELECT * FROM test2__pgspider_srv_2__test2 ORDER BY i, t, t2, __spd_url;
--Testcase 32:
SELECT * FROM test2 ORDER BY i, t, t2, __spd_url;
--Testcase 33:
SELECT t, t2, i FROM test2__pgspider_srv_2__test2 ORDER BY i, t2;
--Testcase 34:
SELECT __spd_url FROM test2__pgspider_srv_2__test2 ORDER BY __spd_url;
--Testcase 35:
SELECT t, t2, i FROM test2 ORDER BY i, t2;
--Testcase 36:
SELECT __spd_url FROM test2 ORDER BY __spd_url;
-- PGSpider Extension does not support SELECT IN
-- -- SELECT IN
-- --Testcase 37:
-- SELECT * FROM test1 IN ('/test1/') ORDER BY i;
-- --Testcase 38:
-- SELECT * FROM test1 IN ('/test1/') WHERE i>0 ORDER BY i;
-- --Testcase 39:
-- SELECT * FROM test2 IN ('/test2/') ORDER BY i;
-- --Testcase 40:
-- SELECT * FROM test2 IN ('/test2/') WHERE i<>500 ORDER BY __spd_url;
-- --Testcase 41:
-- SELECT * FROM test1 IN ('/pgspider_srv_2/influxdb_svr/') ORDER BY i;
--Testcase 42:
SELECT * FROM test1 WHERE __spd_url = '/pgspider_srv_2/influxdb_svr/' ORDER BY i;
-- --Testcase 43:
-- SELECT * FROM test1 IN ('/pgspider_srv_2/griddb_svr/') ORDER BY i;
--Testcase 44:
SELECT * FROM test1 WHERE __spd_url = '/pgspider_srv_2/griddb_svr/' ORDER BY i;
-- --Testcase 45:
-- SELECT * FROM test1 IN ('/pgspider_srv_2/file_svr/') ORDER BY i;
--Testcase 46:
SELECT * FROM test1 WHERE __spd_url = '/pgspider_srv_2/file_svr/' ORDER BY i;
-- --Testcase 47:
-- SELECT * FROM test2 IN ('/pgspider_srv_2/influxdb_svr/') ORDER BY i, t, t2, __spd_url;
--Testcase 48:
SELECT * FROM test2 WHERE __spd_url = '/pgspider_srv_2/influxdb_svr/' ORDER BY i, t, t2, __spd_url;
-- SELECT WHERE
--Testcase 49:
SELECT * FROM test1 WHERE (i + 1000) = 1777 ORDER BY i, __spd_url;
--Testcase 50:
SELECT * FROM test1 WHERE (i * 2) = 44444 ORDER BY i, __spd_url;
--Testcase 51:
SELECT * FROM test1 WHERE i < 5 AND i > 0 ORDER BY i, __spd_url;
--SELECT MAX(i) FROM test1 WHERE i < 2000;

--Testcase 52:
SELECT t, i FROM test2 WHERE (i + 1000) = 1001 ORDER BY i, t, t2, __spd_url;
--Testcase 53:
SELECT * FROM test2 WHERE (i * 2) = 4204 ORDER BY i, t, t2, __spd_url;
--Testcase 54:
SELECT * FROM test2 WHERE i > 0 AND i <> 2103 ORDER BY i, t, t2, __spd_url;
--Testcase 55:
SELECT * FROM test2 WHERE t = 'influx1a' ORDER BY i, t, t2, __spd_url;
--Testcase 56:
SELECT * FROM test2 WHERE t2 IS NULL AND i < 1000 ORDER BY i, t, t2, __spd_url;
--SELECT MAX(i) FROM test2 WHERE i < 2002;

-- GROUP BY with __spd_url tests
--Testcase 78:
EXPLAIN VERBOSE
SELECT i, __spd_url FROM test2 GROUP BY i, __spd_url ORDER BY i;
--Testcase 79:
SELECT i, __spd_url FROM test2 GROUP BY i, __spd_url ORDER BY i;

--Testcase 80:
EXPLAIN VERBOSE
SELECT i, __spd_url FROM test2 GROUP BY __spd_url, i ORDER BY i;
--Testcase 81:
SELECT i, __spd_url FROM test2 GROUP BY __spd_url, i ORDER BY i;

--Testcase 82:
EXPLAIN VERBOSE
SELECT i, __spd_url, __spd_url FROM test2 GROUP BY __spd_url, i ORDER BY i;
--Testcase 83:
SELECT i, __spd_url, __spd_url FROM test2 GROUP BY __spd_url, i ORDER BY i;

--Testcase 84:
EXPLAIN VERBOSE
SELECT __spd_url, i FROM test2 GROUP BY __spd_url, i ORDER BY i;
--Testcase 85:
SELECT __spd_url, i FROM test2 GROUP BY __spd_url, i ORDER BY i;

--Testcase 86:
EXPLAIN VERBOSE
SELECT __spd_url, i FROM test2 GROUP BY i, __spd_url ORDER BY i;
--Testcase 87:
SELECT __spd_url, i FROM test2 GROUP BY i, __spd_url ORDER BY i;

--Testcase 88:
EXPLAIN VERBOSE
SELECT __spd_url, i, __spd_url FROM test2 GROUP BY i, __spd_url ORDER BY i;
--Testcase 89:
SELECT __spd_url, i, __spd_url FROM test2 GROUP BY i, __spd_url ORDER BY i;

--Testcase 90:
EXPLAIN VERBOSE
SELECT avg(i), __spd_url FROM test2 GROUP BY __spd_url;
--Testcase 91:
SELECT avg(i), __spd_url FROM test2 GROUP BY __spd_url;

--Testcase 92:
EXPLAIN VERBOSE
SELECT avg(i), __spd_url, __spd_url FROM test2 GROUP BY __spd_url;
--Testcase 93:
SELECT avg(i), __spd_url, __spd_url FROM test2 GROUP BY __spd_url;

--Testcase 94:
EXPLAIN VERBOSE
SELECT __spd_url, avg(i) FROM test2 GROUP BY __spd_url;
--Testcase 95:
SELECT __spd_url, avg(i) FROM test2 GROUP BY __spd_url;

--Testcase 96:
EXPLAIN VERBOSE
SELECT __spd_url, avg(i), __spd_url FROM test2 GROUP BY __spd_url;
--Testcase 97:
SELECT __spd_url, avg(i), __spd_url FROM test2 GROUP BY __spd_url;

--Testcase 98:
EXPLAIN VERBOSE
SELECT i, __spd_url FROM test1 GROUP BY i, __spd_url ORDER BY 1, 2;
--Testcase 99:
SELECT i, __spd_url FROM test1 GROUP BY i, __spd_url ORDER BY 1, 2;

--Testcase 100:
EXPLAIN VERBOSE
SELECT i, __spd_url FROM test1 GROUP BY __spd_url, i ORDER BY 1, 2;
--Testcase 101:
SELECT i, __spd_url FROM test1 GROUP BY __spd_url, i ORDER BY 1, 2;

--Testcase 102:
EXPLAIN VERBOSE
SELECT i, __spd_url, __spd_url FROM test1 GROUP BY __spd_url, i ORDER BY 1, 2;
--Testcase 103:
SELECT i, __spd_url, __spd_url FROM test1 GROUP BY __spd_url, i ORDER BY 1, 2;

--Testcase 104:
EXPLAIN VERBOSE
SELECT __spd_url, i FROM test1 GROUP BY __spd_url, i ORDER BY 2, 1;
--Testcase 105:
SELECT __spd_url, i FROM test1 GROUP BY __spd_url, i ORDER BY 2, 1;

--Testcase 106:
EXPLAIN VERBOSE
SELECT __spd_url, i FROM test1 GROUP BY i, __spd_url ORDER BY 2, 1;
--Testcase 107:
SELECT __spd_url, i FROM test1 GROUP BY i, __spd_url ORDER BY 2, 1;

--Testcase 108:
EXPLAIN VERBOSE
SELECT __spd_url, i, __spd_url FROM test1 GROUP BY i, __spd_url ORDER BY 2, 1;
--Testcase 109:
SELECT __spd_url, i, __spd_url FROM test1 GROUP BY i, __spd_url ORDER BY 2, 1;

--Testcase 110:
EXPLAIN VERBOSE
SELECT avg(i), __spd_url FROM test1 GROUP BY __spd_url ORDER BY 2;
--Testcase 111:
SELECT avg(i), __spd_url FROM test1 GROUP BY __spd_url ORDER BY 2;

--Testcase 112:
EXPLAIN VERBOSE
SELECT avg(i), __spd_url, __spd_url FROM test1 GROUP BY __spd_url ORDER BY 2;
--Testcase 113:
SELECT avg(i), __spd_url, __spd_url FROM test1 GROUP BY __spd_url ORDER BY 2;

--Testcase 114:
EXPLAIN VERBOSE
SELECT __spd_url, avg(i) FROM test1 GROUP BY __spd_url ORDER BY 1;
--Testcase 115:
SELECT __spd_url, avg(i) FROM test1 GROUP BY __spd_url ORDER BY 1;

--Testcase 116:
EXPLAIN VERBOSE
SELECT __spd_url, avg(i), __spd_url FROM test1 GROUP BY __spd_url ORDER BY 1;
--Testcase 117:
SELECT __spd_url, avg(i), __spd_url FROM test1 GROUP BY __spd_url ORDER BY 1;

-- DROP FOREIGN TABLE
--Testcase 118:
DROP FOREIGN TABLE test1__pgspider_srv_2__test;
--Testcase 132:
DROP FOREIGN TABLE test1_pgspider_srv_child2;

--Testcase 57:
SELECT * FROM test1_pgspider_srv_child2;
--Testcase 58:
SELECT * FROM test1 ORDER BY i, __spd_url;
--Testcase 59:
SELECT * FROM test1 WHERE i = 1 OR i = 777 ORDER BY i, __spd_url ;
--Testcase 119:
DROP FOREIGN TABLE test1__pgspider_srv_1__test;
--Testcase 133:
DROP FOREIGN TABLE test1_pgspider_srv_child1;
--Testcase 60:
SELECT * FROM test1_pgspider_srv_child1;
--Testcase 61:
SELECT * FROM test1 ORDER BY i, __spd_url;
--Testcase 120:
DROP FOREIGN TABLE test2__pgspider_srv_1__test2;
--Testcase 134:
DROP FOREIGN TABLE test2_pgspider_srv_child1;
--Testcase 62:
SELECT * FROM test2 ORDER BY i, t, t2, __spd_url;
--Testcase 121:
DROP FOREIGN TABLE test2__pgspider_srv_2__test2;
--Testcase 135:
DROP FOREIGN TABLE test2_pgspider_srv_child2;
--Testcase 63:
SELECT * FROM test2 ORDER BY i, t, t2, __spd_url;
-- Clean up
--Testcase 122:
DROP USER MAPPING FOR public SERVER pgspider_ext_svr;
--Testcase 123:
DROP USER MAPPING FOR public SERVER pgspider_srv_1;
--Testcase 124:
DROP USER MAPPING FOR public SERVER pgspider_srv_2;
--Testcase 125:
DROP TABLE test1;
--Testcase 126:
DROP TABLE test2;
--Testcase 127:
DROP SERVER pgspider_srv_1;
--Testcase 128:
DROP SERVER pgspider_srv_2;
--Testcase 129:
DROP SERVER pgspider_ext_svr;
--Testcase 130:
DROP EXTENSION pgspider_ext;
--Testcase 131:
DROP EXTENSION postgres_fdw;
