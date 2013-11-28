# 文字コード設定と確認

/etc/my.cnf
character-set-server=utf8
skip-character-set-client-handshake

mysql> status
--------------
～～
Server characterset:    utf8
Db     characterset:    utf8
Client characterset:    utf8
Conn.  characterset:    utf8
～～

# DB作成と確認
mysql> CREATE DATABASE learn1;

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| learn1             |
| mysql              |
+--------------------+

mysqlデータベースにはユーザを管理するuserテーブルなどが保管されている

# DB指定と確認
mysql> use learn1
Database changed

mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| learn1     |
+------------+

# DBを指定してmysqlモニタ起動と確認
[root@localhost ~]# mysql db1 -u root -p
Enter password:

mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| learn1     |
+------------+

# テーブル作成
# emp1テーブル、カラム（number, name, age）
mysql> CREATE TABLE emp1(number INT, name VARCHAR(20), age INT);

# データベースのテーブル一覧表示　ちなSHOWはMySQL地方の方言
mysql> SHOW TABLES;
+------------------+
| Tables_in_learn1 |
+------------------+
| emp1             |
+------------------+

# テーブルでの文字コード指定
mysql> CREATE TABLE emp1(number INT, name VARCHAR(20), age INT) CHARSET=utf8;

# useで指定したDB以外のDBのデータへのアクセス（DB名.テーブル名）
mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| learn1     |
+------------+

mysql> SELECT * FROM mysql.user;

# テーブルのカラム構造の確認
mysql> DESC emp1;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| number | int(11)     | YES  |     | NULL    |       |
| name   | varchar(20) | YES  |     | NULL    |       |
| age    | int(11)     | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+

Field：カラム名
Type：型名　INTの(11)はMySQLが自動で設定したもの
Null：Null値を許可するか否か
Default：何も入れなければこの値にするというデフォルト値
Key, Extraはまた今後

