# Homework 7 Linux CLI Practice
## Overview
In this Homework, I learned how to use some helpful commands in the linux terminal
## Deliverables
### 1: Command: `wc lorem-ipsum.txt -w`
Screenshot: 
![1](./assets/IanCrittenden_HW-7_1_SC.png)
### 2: Command: `wc lorem-ipsum.txt -m`
Screenshot: 
![2](./assets/IanCrittenden_HW-7_2_SC.png)
### 3: Command: `wc lorem-ipsum.txt -l`
Screenshot: 
![3](./assets/IanCrittenden_HW-7_3_SC.png)
### 4: Command: `sort -h file-sizes.txt`
Screenshot: 
![4](./assets/IanCrittenden_HW-7_4_SC.png)
### 5: Command: `sort -h -r file-sizes.txt`
Screenshot: 
![5](./assets/IanCrittenden_HW-7_5_SC.png)
### 6: Command: `cut -d, -f3 log.csv`
Screenshot: 
![6](./assets/IanCrittenden_HW-7_6_SC.png)
### 7: Command: `cut -d, -f2,3 log.csv`
Screenshot: 
![7](./assets/IanCrittenden_HW-7_7_SC.png)
### 8: Command: `cut -d, -f1,4 log.csv`
Screenshot: 
![8](./assets/IanCrittenden_HW-7_8_SC.png)
### 9: Command: `head -n 3 gibberish.txt`
Screenshot: 
![9](./assets/IanCrittenden_HW-7_9_SC.png)
### 10: Command: `tail -n 2 gibberish.txt`
Screenshot: 
![10](./assets/IanCrittenden_HW-7_10_SC.png)
### 11: Command: `tail -n +2 log.csv`
Screenshot: 
![11](./assets/IanCrittenden_HW-7_11_SC.png)
### 12: Command: `grep "and" gibberish.txt`
Screenshot: 
![12](./assets/IanCrittenden_HW-7_12_SC.png)
### 13: Command: `grep -w -n we gibberish.txt`
Screenshot: 
![13](./assets/IanCrittenden_HW-7_13_SC.png)
### 14: Command: `grep -o -P "to \w+" gibberish.txt`
Screenshot: 
![14](./assets/IanCrittenden_HW-7_14_SC.png)
### 15: Command: `grep -c FPGAs fpgas.txt`
Screenshot: 
![15](./assets/IanCrittenden_HW-7_15_SC.png)
### 16: Command: `grep -P "FPGAs are .ot|ower|ile"  fpgas.txt` 
Screenshot: 
![16](./assets/IanCrittenden_HW-7_16_SC.png)
### 17: Command: `grep -c -P "^\s*\-\-" ../../hdl/*/*`
Screenshot: 
![17](./assets/IanCrittenden_HW-7_17_SC.png)
### 18: Command: `ls > ls-output.txt; cat ls-output.txt`
Screenshot: 
![18](./assets/IanCrittenden_HW-7_18_SC.png)
### 19: Command: `sudo dmesg | grep "CPU topo"`
Screenshot: 
![19](./assets/IanCrittenden_HW-7_19_SC.png)  
Note: There were no "CPU topo" instances in the output
### 20: Command: `find ../../hdl/*/* -iname '*vhd' | grep -c "vhd"`
Screenshot: 
![20](./assets/IanCrittenden_HW-7_20_SC.png)
### 21: Command: `grep "\-\-" ../../hdl/*/* | grep -c "\-\-"`
Screenshot: 
![21](./assets/IanCrittenden_HW-7_21_SC.png)
### 22: Command: `grep -n "FPGAs" fpgas.txt | cut -d: -f1`
Screenshot: 
![22](./assets/IanCrittenden_HW-7_22_SC.png)
### 23: Command: `du -h * | sort -h -r | head -n 3`
Screenshot: 
![23](./assets/IanCrittenden_HW-7_23_SC.png)
