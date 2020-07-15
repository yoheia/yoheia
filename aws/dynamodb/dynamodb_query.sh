#!/user/bin/env bash
export LANG=C
id_list=("701001" "701002" "701003" "701004" "701005" "701006" "701007" "701008" "701009" "701010")
start_date='2020-01-01'
end_date='2020-01-31'

file_name=$(basename $0)
stem_name="${file_name%.*}"
log_dir=log
mkdir -p ${log_dir}

for id in ${id_list[@]}
do
	echo $id
	python dynamodb_query.py $id $start_date $end_date > ${log_dir}/${stem_name}_${id}.log &
done

