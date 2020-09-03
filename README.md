# carMintsML
Download and Analyze data recorded using the MINTS ground vehicle - Chevy Volt 


## Operation Pre Requisites 
### UTD VPN 
Inorder to download the data,We need to be get access to the NAS Drive. If running this code off site you need to be within a UTD VPN. The instuctions on being under UTD VPN can be found [here](https://www.utdallas.edu/oit/howto/vpn/).

#### Example shell script to get NAS Drive data under VPN  

```
sshpass -p NASDRIVE_SSH_PW rsync -avzrtu -e ssh --include="*.csv" --include="*/" --exclude="*" mintsdata@10.173.45.235:/volume1/MINTSNASCAR/reference/ /media/teamlary/teamlary3/air930/mintsData/reference
```
**(SSH Pw for the NAS Drive will be provided on request)**

## Operation

Once under UTD VPN the YAML(mintsDefinitions.yaml) file needs to be modified. An example YAML File is given below 
<pre>── <font color="#729FCF"><b>palasAirML</b></font>
│   ├── <font color="#729FCF"><b>firmware</b></font>
│   │   └── <font color="#729FCF"><b>dataProcessing</b></font>
│   │       ├── mintsDefinitions.yaml
│   │       ├── gps0001.m
</pre>

Please choose a directory where you need to create the mints data files with the name 'mintsData'. **Make sure to keep a common 'mintsData' for all MINTS Projects**. Then point to the said folder on the yaml file under the label 'dataFolder'. Under the sshPW field, type in the provided SSH password. In most Mints Data packages are resampled within a pre defined period for synchronizing multiple data samples. To do so the data should be resampled to a unique time period. For the palas data and mints Air Monitoring data sources its fit to resample to a period of 30 seconds. As such 30 can be put under timeSpan. An example implimentation of the YAML file is given below and is also given on the Repo. **Since the YAML file in this case contains secure information(SSH PW) please keep the said file external to the GIT Repo.** 

```
dataFolder: "/media/teamlary/teamlary3/air930/mintsData"
c1PlusID: "001e0610c2e7"
airMarID: "001e0610c2e9"
timeSpan: 30
sshPW: "PW" 
```
Once the YAML file is updated you can run the 'gps0001.m' file under matlab **(Make sure you point to the proper YAML file on the matlab script)**. This should result in creating a .mat file which concatinates all GPS files from the Mints Ground Vehicle. The file is named 'carMintsGPS.mat' and can be found within the folder structure described below.

<pre>── <font color="#729FCF"><b>mintsData</b></font>
│   ├── <font color="#729FCF"><b>referenceMats</b></font>
│   │   └── <font color="#729FCF"><b>carMintsGPS</b></font>
│   │       ├── carMintsGPS.mat

</pre>
The 'carMintsGPS.mat' files contains latititue, longitude cordinate data with its respective date time values. 
