---
menu_title: MySQL
title: Databases - MySQL
permalink: /notes/databases/mysql/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Backup & Restore

### Backup

The command below allow us to backup a single database to a plain text SQL file. This is as simple as it gets to generate a backup.

{% highlight sql %}
mysqldump -u [username] -p [database_name] > [filename].sql
{% endhighlight %}

It is common practice to use the following options when performing a backup:

- `--single-transaction`

This option sets the transaction isolation mode to REPEATABLE READ and sends a START TRANSACTION SQL statement to the server before dumping data. It is useful only with transactional tables such as InnoDB, because then it dumps the consistent state of the database at the time when START TRANSACTION was issued without blocking any applications.

When using this option, you should keep in mind that only InnoDB tables are dumped in a consistent state. For example, any MyISAM or MEMORY tables dumped while using this option may still change state.

While a --single-transaction dump is in process, to ensure a valid dump file (correct table contents and binary log coordinates), no other connection should use the following statements: ALTER TABLE, CREATE TABLE, DROP TABLE, RENAME TABLE, TRUNCATE TABLE. A consistent read is not isolated from those statements, so use of them on a table to be dumped can cause the SELECT that is performed by mysqldump to retrieve the table contents to obtain incorrect contents or fail.

The --single-transaction option and the --lock-tables option are mutually exclusive because LOCK TABLES causes any pending transactions to be committed implicitly.

To dump large tables, combine the --single-transaction option with the --quick option.

- `--opt`

This option, enabled by default, is shorthand for the combination of --add-drop-table --add-locks --create-options --disable-keys --extended-insert --lock-tables --quick --set-charset. It gives a fast dump operation and produces a dump file that can be reloaded into a MySQL server quickly.

Because the --opt option is enabled by default, you only specify its converse, the --skip-opt to turn off several default settings. See the discussion of mysqldump option groups for information about selectively enabling or disabling a subset of the options affected by --opt.

### Backup with Options

If we also add the options above, it would become something as:

{% highlight sql %}
mysqldump -u [username] -p --single-transaction --opt [database_name] > [filename].sql
{% endhighlight %}

### Restore

We can restore a previously created database file by using the `mysql` command:

{% highlight sql %}
mysql -u [username] -p [database_name] < [filename].sql
{% endhighlight %}
