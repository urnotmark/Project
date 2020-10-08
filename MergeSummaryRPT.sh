#! /bin/bash



day=`date -d "0 days ago" +%Y%m%d`

scp -r root@dsu1:/data/act_logs/Statistic/MoveVMS_${day}.txt /root/vmstatistic/RemoveVMSSUB 

scp -r root@dsu1:/data/act_logs/Statistic/OUTPUTRPT_${day}.txt /root/vmstatistic/RemoveVMSSUB

scp -r root@dsu1:/data/act_logs/Statistic/removelist.${day}.tmp /root/vmstatistic/RemoveVMSSUB
 
[root@smu1a ~/vmstatistic/RemoveVMSSUB]# more MergeSummaryRPT.sh 
#! /bin/bash

day=`date +%Y%m%d`

#OUTPUT SUCCESS NUMBER LIST
cat MoveVMS_${day}.txt.resp|grep "Operation Successful\|Failed"|awk -F, '{print $4}' > numberlist.txt

cat numberlist.txt|cut -c8-20 > Result_RemoveVMS_Success.txt

rm -f numberlist.txt

#OUTPUT FAILED NUMBER LIST
cat MoveVMS_${day}.txt.resp|grep "Service not provisioned"|awk -F, '{print $4}' > failedlist.txt

cat failedlist.txt|cut -c8-20 > Result_RemoveVMS_Failed.txt

rm -f failedlist.txt

sed -e "s/^/D /g" Result_RemoveVMS_Failed.txt > Batch_D_OperationWithFailed_${day}.txt

sed -i '$a end of data' Batch_D_OperationWithFailed_${day}.txt

#PROCESS FORMAT OF JOIN FILES
cat removelist.${day}.tmp|cut -c4-20 > removelist.${day}.tmp.new

sed -i "s/$/ `date +%Y%m%d`/g" Result_RemoveVMS_Success.txt

sort -n Result_RemoveVMS_Success.txt > mark1.txt

sort -n removelist.${day}.tmp.new > mark2.txt

rm -f removelist.${day}.tmp.new

join -a1 -o 1.1 2.2 1.2 mark1.txt mark2.txt|uniq >> Summary_RemoveVMS_Success_Report.txt

rm -f mark1.txt

rm -f mark2.txt
