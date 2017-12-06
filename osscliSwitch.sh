#!/bin/sh
set -x
set -e
echo "./osscliSwitch.sh source-dir target-name http-url"
BASEDIR=$1
BIGC=$(echo $2 | tr '[:lower:]' '[:upper:]')
TAGETC=$2
WWWADD=$3

execdir(){
    cd $1
    for fd in ` ls `;do
       if [ -d ${fd} ]; then
	   execdir ${fd}
       elif [ -f ${fd} ];then
           `sed -i "s/aws.amazon.com/${WWWADD}/g" ${fd}`
           `sed -i "s/amazon/${TAGETC}/g" ${fd}`
           `sed -i "s/Amazonaws/${TAGETC}/g" ${fd}` 
           `sed -i "s/Amazon/${TAGETC}/g" ${fd}`
           `sed -i "s/AWS/${BIGC}/g" ${fd}`
           `sed -i "s/aws/${TAGETC}/g" ${fd}`
           `sed -i "s/${TAGETC}_access_key_id/aws_access_key_id/g" ${fd}`
           `sed -i "s/${TAGETC}_secret_access_key/aws_secret_access_key/g" ${fd}`
           `sed -i "s/${TAGETC}request/awsrequest/g" ${fd}`
           `sed -i "s/${BIGC}Request/AWSRequest/g" ${fd}`
           sleep 0.1
       fi
    done
    cd ..
}

chanageName(){
   cd $1
   local cur_dir 
   for fd in `ls`; do
       if [ -d ${fd} ];then
          cur_dir=${fd}
          chanageName ${fd}
          if  [[ ${cur_dir} == *aws* ]]; then
             filename=${cur_dir//"aws"/"${TAGETC}"}
             `mv ${cur_dir} ${filename}`
              sleep 0.1
          fi
        elif [[ -f ${fd} ]];then
          if  [[ ${fd} == *aws* ]]; then
              filename=${fd//"aws"/"${TAGETC}"}
              `mv ${fd} ${filename}`
              sleep 0.1
          fi
       fi
   done
   cd ..
}

execdir ${BASEDIR}
chanageName ${BASEDIR}
topname=${BASEDIR//"aws"/"${TAGETC}"}
`mv ${BASEDIR} ${topname}`
