#ifndef MONITORING_SYSTEM_H
#define MONITORING_SYSTEM_H

#include<iostream>
#include<stdint.h>
#include<time.h>
#include<fstream>
using namespace std;

#define NUM_OF_SERVERS 1000 /*Number of servers*/
#define MINUTES_IN_A_DAY 1440 /* Number of minutes in a day 24*60 */

/*Monitoring sytem Server Structure */
typedef struct monitoring_system_t
{
	int unix_timestamp;		//unix timestamp;
	uint16_t ip[4];			//Ip address
	uint16_t cpu_1;			//CPU 1 with id 0
	uint16_t cpu_2;			//CPU 2 with id 1
	uint16_t cpu_usage_1;	//% of CPU usage of CPU 1
	uint16_t cpu_usage_2;	//% of CPU usage of CPU 2
}monitoring_system;

#endif
