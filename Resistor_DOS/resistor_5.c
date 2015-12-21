#include "stdio.h"
#include "string.h"

void cls(void);
void prt_resi(void);

int main(void)
{
	char clr[5] = {0};
	char clr1[10] = {"nothing"};
	char clr2[10] = {"nothing"};
	char clr3[10] = {"nothing"};
	char clr4[10] = {"nothing"};
	char clr5[10] = {"nothing"};
	char input = 0;
	float resi = 0;
	char tole[10] = {};
	
	resi = 0;
	strncpy(tole,"",7);

//  ##############################################
//	##	Color 1									##
//	##############################################
	
	do
	{
		cls();
		input = 0;
		
		prt_resi();
		
		printf("\n\t-[ 1: brown | %s  | %s  | %s  | %s  ]-", clr2, clr3, clr4, clr5);
		printf("\n\t   2: red");
		printf("\n\t   3: orange");
		printf("\n\t   4: yellow");
		printf("\n\t   5: green");
		printf("\n\t   6: blue");
		printf("\n\t   7: purple");
		printf("\n\t   8: gray");
		printf("\n\t   9: white\n\n\n");
		printf("\n\nChoose color 1:\t");
		scanf("%c", &input);
		fflush(stdin);
		clr[0] = input;
		
		switch (input)
		{
			case ('1'):
				strncpy(clr1,"brown  ",7);
				resi = 100;
				break;
			case ('2'):
				strncpy(clr1,"red    ",7);
				resi = 200;
				break;
			case ('3'):
				strncpy(clr1,"orange ",7);
				resi = 300;
				break;
			case ('4'):
				strncpy(clr1,"yellow ",7);
				resi = 400;
				break;
			case ('5'):
				strncpy(clr1,"green  ",7);
				resi = 500;
				break;
			case ('6'):
				strncpy(clr1,"blue   ",7);
				resi = 600;
				break;
			case ('7'):
				strncpy(clr1,"purple ",7);
				resi = 700;
				break;
			case ('8'):
				strncpy(clr1,"gray   ",7);
				resi = 800;
				break;
			case ('9'):
				strncpy(clr1,"white  ",7);
				resi = 900;
				break;
			default:
				strncpy(clr1,"error  ",7);
				break;
		}
	}
	while (clr1[0] == 'e');

//  ##############################################
//	##	Color 2									##
//	##############################################

	do
	{	
		cls();
		input = 0;
		
		prt_resi();
		
		printf("\n\t-[ %s  | 1: brown | %s  | %s  | %s  ]-", clr1, clr3, clr4, clr5);
		printf("\n\t              2: red");
		printf("\n\t              3: orange");
		printf("\n\t              4: yellow");
		printf("\n\t              5: green");
		printf("\n\t              6: blue");
		printf("\n\t              7: purple");
		printf("\n\t              8: gray");
		printf("\n\t              9: white");
		printf("\n\t              0: black\n\n");
		printf("\n\nChoose color 2:\t");
		scanf("%c", &input);
		fflush(stdin);
		clr[1] = input;
		
		switch (input)
		{
			case ('1'):
				strncpy(clr2,"brown  ",7);
				resi += 10;
				break;
			case ('2'):
				strncpy(clr2,"red    ",7);
				resi += 20;
				break;
			case ('3'):
				strncpy(clr2,"orange ",7);
				resi += 30;
				break;
			case ('4'):
				strncpy(clr2,"yellow ",7);
				resi += 40;
				break;
			case ('5'):
				strncpy(clr2,"green  ",7);
				resi += 50;
				break;
			case ('6'):
				strncpy(clr2,"blue   ",7);
				resi += 60;
				break;
			case ('7'):
				strncpy(clr2,"purple ",7);
				resi += 70;
				break;
			case ('8'):
				strncpy(clr2,"gray   ",7);
				resi += 80;
				break;
			case ('9'):
				strncpy(clr2,"white  ",7);
				resi += 90;
				break;
			case ('0'):
				strncpy(clr2,"black  ",7);
				resi += 0;
				break;
			default:
				strncpy(clr2,"error  ",7);
				break;
		}
	}
	while (clr2[0] == 'e');
	
//  ##############################################
//	##	Color 3									##
//	##############################################

	do
	{	
		cls();
		input = 0;
		
		prt_resi();
		
		printf("\n\t-[ %s  | %s  | 1: brown | %s  | %s  ]-", clr1, clr2, clr4, clr5);
		printf("\n\t                         2: red");
		printf("\n\t                         3: orange");
		printf("\n\t                         4: yellow");
		printf("\n\t                         5: green");
		printf("\n\t                         6: blue");
		printf("\n\t                         7: purple");
		printf("\n\t                         8: gray");
		printf("\n\t                         9: white");
		printf("\n\t                         0: black\n\n");
		printf("\n\nChoose color 3:\t");
		scanf("%c", &input);
		fflush(stdin);
		clr[2] = input;
		
		switch (input)
		{
			case ('1'):
				strncpy(clr3,"brown  ",7);
				resi += 1;
				break;
			case ('2'):
				strncpy(clr3,"red    ",7);
				resi += 2;
				break;
			case ('3'):
				strncpy(clr3,"orange ",7);
				resi += 3;
				break;
			case ('4'):
				strncpy(clr3,"yellow ",7);
				resi += 4;
				break;
			case ('5'):
				strncpy(clr3,"green  ",7);
				resi += 5;
				break;
			case ('6'):
				strncpy(clr3,"blue   ",7);
				resi += 6;
				break;
			case ('7'):
				strncpy(clr3,"purple ",7);
				resi += 7;
				break;
			case ('8'):
				strncpy(clr3,"gray   ",7);
				resi += 8;
				break;
			case ('9'):
				strncpy(clr3,"white  ",7);
				resi += 9;
				break;
			case ('0'):
				strncpy(clr3,"black  ",7);
				resi += 0;
				break;
			default:
				strncpy(clr3,"error  ",7);
				break;
		}
	}
	while (clr3[0] == 'e');

//  ##############################################
//	##	Color 4									##
//	##############################################

	do
	{	
		cls();
		input = 0;
		
		prt_resi();
		
		printf("\n\t-[ %s  | %s  | %s  | 1: brown | %s  ]-", clr1, clr2, clr3, clr5);
		printf("\n\t                                    2: red");
		printf("\n\t                                    3: orange");
		printf("\n\t                                    4: yellow");
		printf("\n\t                                    5: green");
		printf("\n\t                                    6: blue");
		printf("\n\t                                    7: black");
		printf("\n\t                                    8: silver");
		printf("\n\t                                    9: gold\n\n\n");
		printf("\n\nChoose color 4:\t");
		scanf("%c", &input);
		fflush(stdin);
		clr[3] = input;
		
		switch (input)
		{
			case ('1'):
				strncpy(clr4,"brown  ",7);
				resi *= 10;
				break;
			case ('2'):
				strncpy(clr4,"red    ",7);
				resi *= 100;
				break;
			case ('3'):
				strncpy(clr4,"orange ",7);
				resi *= 1000;
				break;
			case ('4'):
				strncpy(clr4,"yellow ",7);
				resi *= 10000;
				break;
			case ('5'):
				strncpy(clr4,"green  ",7);
				resi *= 100000;
				break;
			case ('6'):
				strncpy(clr4,"blue   ",7);
				resi *= 1000000;
				break;
			case ('7'):
				strncpy(clr4,"black  ",7);
				resi *= 1;
				break;
			case ('8'):
				strncpy(clr4,"silver ",7);
				resi *= 0.01;
				break;
			case ('9'):
				strncpy(clr4,"gold   ",7);
				resi *= 0.1;
				break;
			default:
				strncpy(clr4,"error  ",7);
				break;
		}
	}
	while (clr4[0] == 'e');

//  ##############################################
//	##	Color 5									##
//	##############################################

	do
	{	
		cls();
		input = 0;
		
		prt_resi();
		
		printf("\n\t-[ %s  | %s  | %s  | %s  | 1: brown ]-", clr1, clr2, clr3, clr4);
		printf("\n\t                                               2: red");
		printf("\n\t                                               3: green");
		printf("\n\t                                               4: blue");
		printf("\n\t                                               5: purple");
		printf("\n\t                                               6: gray\n\n\n\n\n\n");
		printf("\n\nChoose color 5:\t");
		scanf("%c", &input);
		fflush(stdin);
		clr[4] = input;
		
		switch (input)
		{
			case ('1'):
				strncpy(clr5,"brown  ",7);
				strncpy(tole,"+- 1%",7);
				break;
			case ('2'):
				strncpy(clr5,"red    ",7);
				strncpy(tole,"+- 2%",7);
				break;
			case ('3'):
				strncpy(clr5,"green  ",7);
				strncpy(tole,"+- 0.5%",7);
				break;
			case ('4'):
				strncpy(clr5,"blue   ",7);
				strncpy(tole,"+- 0.25%",7);
				break;
			case ('5'):
				strncpy(clr5,"purple ",7);
				strncpy(tole,"+- 0.1%",7);
				break;
			case ('6'):
				strncpy(clr5,"gray   ",7);
				strncpy(tole,"+- 0.05%",7);
				break;
			default:
				strncpy(clr5,"error  ",7);
				break;
		}
	}
	while (clr5[0] == 'e');	
	

//  ##############################################
//	##	Final Output							##
//	##############################################
	
	cls();
	input = 0;
	
	prt_resi();
	
	printf("\n\t-[ %s  | %s  | %s  | %s  | %s  ]-\n\n", clr1, clr2, clr3, clr4, clr5);
	printf("\t= %.2lf %s Ohm\n\n\n\n\n\n\n\n\n\n\n", resi, tole);
	
	system("pause");
	
	return 0;
}

void cls(void)
{
	system("cls");
	
	return;
}

void prt_resi(void)
{
	printf("\n\t-[ 1 | 2 | 3 | 4 |   | 5 ]-   or   -[ 1 | 2 | 3 | 4 | 5 |    ]-\n\n\n");
	return;
}

