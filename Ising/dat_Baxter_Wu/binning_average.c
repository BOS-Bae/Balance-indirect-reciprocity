#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

int main(int argc, char **argv){

	// Get bond(J) configuration
	char filename[30] = "L";
	strcat(filename,argv[1]);
	strcat(filename,"/L");
	strcat(filename,argv[1]);
	strcat(filename,"T");
	strcat(filename,argv[2]);
    strcat(filename,".dat");
	double L = atof(argv[1]);
  	FILE *fp = fopen(filename,"r");
	int num_sample, MCS, t_ms,t_thm;
	MCS = atoi(argv[3]);
	t_ms = atoi(argv[4]);
	t_thm = atoi(argv[5]);
	int b,k;
	num_sample = (int)((MCS-t_thm)/t_ms);
	double n_sample = (double)num_sample;

	double data[MCS][3];
	double data_sl[num_sample][3];

	if (fp != NULL){
		for (b=0; b<MCS; b++){
			for (k=0; k<3; k++){
				fscanf(fp, "%lf", &data[b][k]);
			}
		}
		fclose(fp);
	}
	double avg_E, avg_c, T;
	avg_E = avg_c = 0.0;
	T = 0.0;
	double avg_1_t, avg_E_t, avg_E2_t;
	avg_1_t = avg_E_t = avg_E2_t = 0.0;
	
	int t_idx = 0;
	for (b=t_thm-1;b<MCS;b++){
		if ((b+t_ms-t_thm+1) % t_ms == 0) {
			data_sl[t_idx][0] = data[b][0];
			data_sl[t_idx][1] = avg_E_t;
			data_sl[t_idx][2] = (avg_E2_t - avg_E_t*avg_E_t)/(data[b][0]*data[b][0]);

			t_idx += 1;
			avg_E_t = avg_E2_t = 0.0;
		}
		avg_E_t += data[b][1]/t_ms;
		avg_E2_t += data[b][2]/t_ms; // E squared
	}
	
	for (b=0;b<n_sample;b++){
		T += data_sl[b][0]/n_sample;
		avg_E += data_sl[b][1]/n_sample;
		avg_c += data_sl[b][2]/n_sample;
	}
	double std_err_E, std_err_c;
	std_err_E = std_err_c = 0.0;
	for (b=0;b<num_sample;b++){
		std_err_E += pow((data_sl[b][1] - avg_E),2) / (n_sample-1);
		std_err_c += pow((data_sl[b][2] - avg_c),2) / (n_sample-1);
	}
	std_err_E = sqrt(std_err_E / n_sample);
	std_err_c = sqrt(std_err_c / n_sample);
	
	printf("%lf", T);
	printf("    ");
	printf("%lf", (avg_E/L/L));
	printf("    ");
	printf("%lf", (std_err_E/L/L));
	printf("    ");
	printf("%lf", (avg_c/L/L));
	printf("    ");
	printf("%lf", (std_err_c/L/L));
	printf("\n");
	return 0;
}
