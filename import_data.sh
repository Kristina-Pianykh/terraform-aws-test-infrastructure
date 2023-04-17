#!/bin/bash

# parse arguments
while getopts ":u:p:d:P:h:t:f:" opt; do
  case $opt in
    u) user="$OPTARG"
    ;;
    p) password="$OPTARG"
    ;;
    d) db_name="$OPTARG"
    ;;
    P) port="$OPTARG"
    ;;
    h) host="$OPTARG"
    ;;
    t) table="$OPTARG"
    ;;
    f) file="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  # Check if any argument is empty (in case it's followed by another option)
  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

# Check if all arguments are set
declare -a params=("user" "password" "db_name" "port" "host" "table")
for param in "${params[@]}";
do
    eval "value=\${$param}"
    if [ -z "$value" ]; then
        echo "ERROR: $param is not set."
        exit 1
    fi
done


# create table
# sql_command="$(cat << EOF
#   GRANT SESSION_VARIABLES_ADMIN ON *.* TO $user';
#   USE $db_name;
#   CREATE TABLE IF NOT EXISTS $table (
#     hero_id int,
#     attribute_id int,
#     attribute_value int
#     );
#   LOAD DATA INFILE $file
#   INTO TABLE $table
#   FIELDS TERMINATED BY ','
#   ENCLOSED BY '"'
#   LINES TERMINATED BY '\n'
#   IGNORE 1 ROWS;
# EOF
# )"

# sql_command="GRANT SESSION_VARIABLES_ADMIN ON *.* TO $user;"

sql_command="$(cat << EOF
  GRANT SESSION_VARIABLES_ADMIN ON *.* TO $user;
  USE $db_name;
  CREATE TABLE IF NOT EXISTS $table (
    hero_id int,
    attribute_id int,
    attribute_value int
    );
EOF
)"

mysql \
    -h $host \
    -u $user \
    -P $port \
    --password=$password \
    -e "$sql_command"

# # split large file into smaller files
split -C 1024m -d $file $table.part_

# # import splitted files into database
mysqlimport --local \
    --compress \
    --user=$user \
    --password=$password \
    --host=$host \
    --fields-terminated-by=',' $db_name $table.part_*


# mysqlimport --local \
#     --compress \
#     --user="admin" \
#     --password="0CAD2FB5D9" \
#     --host="my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com" \
#     --fields-terminated-by=',' mydb hero_attribute.part_*
